-- =====================================================================
-- O Pacificador de Famílias · Salas de debate · Banco de dados (fase 2)
-- =====================================================================
-- Como usar: no painel do Supabase, abra "SQL Editor", cole este arquivo
-- inteiro e clique em "Run". Pode ser rodado de novo sem perder dados:
-- tudo usa "if not exists" ou "create or replace".
--
-- Segurança: a proteção dos dados está nas políticas de acesso (RLS)
-- abaixo. A chave pública (anon / publishable) que vai no site só
-- consegue o que estas políticas permitem. A chave secreta
-- (service_role / secret) NUNCA vai para o site nem para o repositório.
--
-- LGPD: inscrição em sala e reação podem revelar opinião política, dado
-- sensível (Lei 13.709/2018, art. 11). Por isso: cada pessoa só vê as
-- próprias inscrições e reações; o público vê apenas totais; quem não
-- registrou consentimento não consegue gravar nada.
-- =====================================================================

-- ---------- Tipos ----------
do $$ begin
  create type public.papel_t as enum ('participante', 'curador', 'admin');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.estado_sala_t as enum (
    'proposta',      -- cadastrada por um participante, só o autor e a curadoria veem
    'em_validacao',  -- curadoria rodando /pacificador-validar
    'aberta',        -- visível a todos; inscrições abertas
    'no_conselho',   -- rodada do Conselho em andamento
    'em_revisao',    -- revisão humana de isonomia
    'publicada',     -- Sentença publicada; reações abertas
    'em_debate',     -- debate em curso (comentários entram na fase 3)
    'arquivada',     -- só leitura
    'recusada'       -- não cabe no Conselho; só o autor e a curadoria veem
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.reacao_t as enum (
    'aprendi',     -- 💡 Aprendi algo
    'mudei',       -- 🔄 Mudei de ideia em algo
    'reconheco',   -- 🤝 Reconheço um acerto do outro lado
    'mais_dados',  -- 🔍 Quero mais dados
    'discordo'     -- ⚖️ Discordo, e sei explicar por quê
  );
exception when duplicate_object then null; end $$;

-- ---------- Perfis ----------
create table if not exists public.perfis (
  id                uuid primary key references auth.users (id) on delete cascade,
  apelido           text not null check (char_length(btrim(apelido)) between 2 and 40),
  papel             public.papel_t not null default 'participante',
  consentimento_em  timestamptz not null,   -- aceite da Política de Privacidade (LGPD)
  regras_aceitas_em timestamptz not null,   -- aceite das Regras da Mesa
  criado_em         timestamptz not null default now()
);

-- ---------- Salas ----------
create table if not exists public.salas (
  id             uuid primary key default gen_random_uuid(),
  slug           text unique check (slug ~ '^[a-z0-9-]{3,90}$'),
  pergunta       text not null check (char_length(pergunta) between 15 and 400),
  por_que        text check (char_length(por_que) <= 800),
  esfera         text not null default 'nao_sei'
                 check (esfera in ('municipal', 'estadual', 'federal', 'internacional', 'varias', 'nao_sei')),
  estado         public.estado_sala_t not null default 'proposta',
  autor_id       uuid references public.perfis (id) on delete set null,
  nota_curadoria text check (char_length(nota_curadoria) <= 1500),
  sentenca_base  text check (sentenca_base ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}_S-[0-9]{3,}_[a-z0-9-]+$'),
  criado_em      timestamptz not null default now(),
  atualizado_em  timestamptz not null default now()
);
create index if not exists salas_estado_idx on public.salas (estado);

-- ---------- Inscrições ----------
create table if not exists public.inscricoes (
  sala_id       uuid not null references public.salas (id) on delete cascade,
  user_id       uuid not null references public.perfis (id) on delete cascade,
  quer_conselho boolean not null default false,  -- "quero que vá ao Conselho"
  criado_em     timestamptz not null default now(),
  primary key (sala_id, user_id)
);

-- ---------- Reações da missão ----------
create table if not exists public.reacoes (
  sala_id   uuid not null references public.salas (id) on delete cascade,
  user_id   uuid not null references public.perfis (id) on delete cascade,
  tipo      public.reacao_t not null,
  criado_em timestamptz not null default now(),
  primary key (sala_id, user_id, tipo)
);

-- ---------- Anexos (enviados pela curadoria) ----------
create table if not exists public.anexos (
  id          uuid primary key default gen_random_uuid(),
  sala_id     uuid not null references public.salas (id) on delete cascade,
  titulo      text not null check (char_length(titulo) between 2 and 140),
  caminho     text not null,          -- caminho no bucket "anexos" do Storage
  enviado_por uuid references public.perfis (id) on delete set null,
  criado_em   timestamptz not null default now()
);

-- ---------- Candidaturas a curador ----------
create table if not exists public.candidaturas_curador (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null unique references public.perfis (id) on delete cascade,
  motivacao   text not null check (char_length(motivacao) between 20 and 1000),
  estado      text not null default 'pendente' check (estado in ('pendente', 'aprovada', 'recusada')),
  criado_em   timestamptz not null default now(),
  decidido_em timestamptz
);

-- =====================================================================
-- Funções auxiliares
-- =====================================================================

create or replace function public.e_curador()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.perfis
                 where id = auth.uid() and papel in ('curador', 'admin'));
$$;

create or replace function public.e_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.perfis where id = auth.uid() and papel = 'admin');
$$;

create or replace function public.tem_perfil()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.perfis where id = auth.uid());
$$;

-- Estados em que a sala é visível a todos
create or replace function public.sala_publica(e public.estado_sala_t)
returns boolean language sql immutable as $$
  select e not in ('proposta', 'em_validacao', 'recusada');
$$;

-- Slug a partir da pergunta: "Quero entender por que os homicídios caíram"
-- vira "por-que-os-homicidios-cairam-3f9a1".
create or replace function public.gerar_slug(txt text)
returns text language plpgsql as $$
declare s text;
begin
  s := lower(translate(txt,
        'áàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ',
        'aaaaaeeeeiiiiooooouuuucnaaaaaeeeeiiiiooooouuuucn'));
  s := regexp_replace(s, '^\s*quero entender\s*', '');
  s := regexp_replace(s, '[^a-z0-9]+', '-', 'g');
  s := btrim(s, '-');
  s := left(s, 60);
  s := btrim(s, '-');
  if char_length(s) < 3 then s := 'sala'; end if;
  return s || '-' || substr(md5(random()::text || clock_timestamp()::text), 1, 5);
end $$;

-- Antes de gravar uma sala: gera o slug e protege campos que só a curadoria muda
create or replace function public.salas_antes_de_gravar()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if tg_op = 'INSERT' then
    new.slug := public.gerar_slug(new.pergunta);
    new.criado_em := now();
    -- limite contra spam: até 5 propostas por pessoa a cada 24 horas
    if not public.e_curador() and (
         select count(*) from public.salas
         where autor_id = auth.uid() and criado_em > now() - interval '24 hours') >= 5 then
      raise exception 'Limite de 5 propostas por dia atingido. Tente amanhã.';
    end if;
  else
    new.slug := old.slug;              -- o endereço da sala nunca muda
    -- o autor não muda; só pode virar nulo quando a pessoa apaga a conta
    if new.autor_id is not null then new.autor_id := old.autor_id; end if;
    new.criado_em := old.criado_em;
  end if;
  new.atualizado_em := now();
  return new;
end $$;

drop trigger if exists salas_antes_de_gravar on public.salas;
create trigger salas_antes_de_gravar before insert or update on public.salas
  for each row execute function public.salas_antes_de_gravar();

-- Totais públicos por sala (só agregados; nunca quem fez o quê)
create or replace function public.resumo_salas()
returns table (
  sala_id uuid, inscritos bigint, querem_conselho bigint,
  aprendi bigint, mudei bigint, reconheco bigint, mais_dados bigint, discordo bigint
) language sql stable security definer set search_path = public as $$
  select s.id,
         (select count(*) from public.inscricoes i where i.sala_id = s.id),
         (select count(*) from public.inscricoes i where i.sala_id = s.id and i.quer_conselho),
         (select count(*) from public.reacoes r where r.sala_id = s.id and r.tipo = 'aprendi'),
         (select count(*) from public.reacoes r where r.sala_id = s.id and r.tipo = 'mudei'),
         (select count(*) from public.reacoes r where r.sala_id = s.id and r.tipo = 'reconheco'),
         (select count(*) from public.reacoes r where r.sala_id = s.id and r.tipo = 'mais_dados'),
         (select count(*) from public.reacoes r where r.sala_id = s.id and r.tipo = 'discordo')
  from public.salas s
  where public.sala_publica(s.estado) or s.autor_id = auth.uid() or public.e_curador();
$$;

-- As propostas da própria pessoa (o autor de cada sala não é exposto a terceiros)
create or replace function public.minhas_salas()
returns table (id uuid, slug text, pergunta text, estado public.estado_sala_t, nota_curadoria text, criado_em timestamptz)
language sql stable security definer set search_path = public as $$
  select s.id, s.slug, s.pergunta, s.estado, s.nota_curadoria, s.criado_em
  from public.salas s where s.autor_id = auth.uid() and auth.uid() is not null
  order by s.criado_em desc;
$$;

-- Apagar a própria conta (LGPD): remove o login e, em cascata, perfil,
-- inscrições, reações e candidatura. Salas propostas ficam sem autor.
create or replace function public.apagar_minha_conta()
returns void language plpgsql security definer set search_path = public, auth as $$
begin
  if auth.uid() is null then raise exception 'Não autenticado.'; end if;
  delete from auth.users where id = auth.uid();
end $$;

-- Mudar o papel de alguém (somente admin)
create or replace function public.definir_papel(alvo uuid, novo public.papel_t)
returns void language plpgsql security definer set search_path = public as $$
begin
  if not public.e_admin() then raise exception 'Somente administradores.'; end if;
  update public.perfis set papel = novo where id = alvo;
end $$;

-- Lista de candidaturas com apelido (somente admin)
create or replace function public.listar_candidaturas()
returns table (id uuid, user_id uuid, apelido text, motivacao text, estado text, criado_em timestamptz)
language sql stable security definer set search_path = public as $$
  select c.id, c.user_id, p.apelido, c.motivacao, c.estado, c.criado_em
  from public.candidaturas_curador c join public.perfis p on p.id = c.user_id
  where public.e_admin()
  order by c.estado = 'pendente' desc, c.criado_em;
$$;

-- Decidir candidatura (somente admin); aprovar promove a curador
create or replace function public.decidir_candidatura(cand uuid, aprovar boolean)
returns void language plpgsql security definer set search_path = public as $$
declare u uuid;
begin
  if not public.e_admin() then raise exception 'Somente administradores.'; end if;
  update public.candidaturas_curador
     set estado = case when aprovar then 'aprovada' else 'recusada' end, decidido_em = now()
   where id = cand returning user_id into u;
  if aprovar and u is not null then
    update public.perfis set papel = 'curador' where id = u and papel = 'participante';
  end if;
end $$;

-- =====================================================================
-- Políticas de acesso (RLS)
-- =====================================================================
alter table public.perfis               enable row level security;
alter table public.salas                enable row level security;
alter table public.inscricoes           enable row level security;
alter table public.reacoes              enable row level security;
alter table public.anexos               enable row level security;
alter table public.candidaturas_curador enable row level security;

-- Perfis: cada um vê e cria o próprio; só o apelido pode ser alterado
drop policy if exists perfis_ver_proprio on public.perfis;
create policy perfis_ver_proprio on public.perfis for select to authenticated
  using (id = auth.uid());
drop policy if exists perfis_criar_proprio on public.perfis;
create policy perfis_criar_proprio on public.perfis for insert to authenticated
  with check (id = auth.uid() and papel = 'participante');
drop policy if exists perfis_editar_proprio on public.perfis;
create policy perfis_editar_proprio on public.perfis for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

-- Salas
drop policy if exists salas_ver on public.salas;
create policy salas_ver on public.salas for select to anon, authenticated
  using (public.sala_publica(estado) or autor_id = auth.uid() or public.e_curador());
drop policy if exists salas_propor on public.salas;
create policy salas_propor on public.salas for insert to authenticated
  with check (public.tem_perfil() and autor_id = auth.uid() and estado = 'proposta'
              and nota_curadoria is null and sentenca_base is null);
drop policy if exists salas_curadoria_editar on public.salas;
create policy salas_curadoria_editar on public.salas for update to authenticated
  using (public.e_curador()) with check (public.e_curador());
drop policy if exists salas_apagar on public.salas;
create policy salas_apagar on public.salas for delete to authenticated
  using (public.e_curador() or (autor_id = auth.uid() and estado = 'proposta'));

-- Inscrições: só as próprias; só em salas visíveis e ainda ativas
drop policy if exists inscricoes_ver_proprias on public.inscricoes;
create policy inscricoes_ver_proprias on public.inscricoes for select to authenticated
  using (user_id = auth.uid());
drop policy if exists inscricoes_criar on public.inscricoes;
create policy inscricoes_criar on public.inscricoes for insert to authenticated
  with check (user_id = auth.uid() and public.tem_perfil() and exists (
    select 1 from public.salas s where s.id = sala_id
      and s.estado in ('aberta', 'no_conselho', 'em_revisao', 'publicada', 'em_debate')));
drop policy if exists inscricoes_editar on public.inscricoes;
create policy inscricoes_editar on public.inscricoes for update to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists inscricoes_apagar on public.inscricoes;
create policy inscricoes_apagar on public.inscricoes for delete to authenticated
  using (user_id = auth.uid());

-- Reações: só as próprias; só depois da Sentença publicada
drop policy if exists reacoes_ver_proprias on public.reacoes;
create policy reacoes_ver_proprias on public.reacoes for select to authenticated
  using (user_id = auth.uid());
drop policy if exists reacoes_criar on public.reacoes;
create policy reacoes_criar on public.reacoes for insert to authenticated
  with check (user_id = auth.uid() and public.tem_perfil() and exists (
    select 1 from public.salas s where s.id = sala_id and s.estado in ('publicada', 'em_debate')));
drop policy if exists reacoes_apagar on public.reacoes;
create policy reacoes_apagar on public.reacoes for delete to authenticated
  using (user_id = auth.uid());

-- Anexos: leitura acompanha a visibilidade da sala; escrita só curadoria
drop policy if exists anexos_ver on public.anexos;
create policy anexos_ver on public.anexos for select to anon, authenticated
  using (exists (select 1 from public.salas s where s.id = sala_id));
drop policy if exists anexos_curadoria_criar on public.anexos;
create policy anexos_curadoria_criar on public.anexos for insert to authenticated
  with check (public.e_curador() and enviado_por = auth.uid());
drop policy if exists anexos_curadoria_apagar on public.anexos;
create policy anexos_curadoria_apagar on public.anexos for delete to authenticated
  using (public.e_curador());

-- Candidaturas: cada um cria e vê a própria; decisão pela função de admin
drop policy if exists candidaturas_ver_propria on public.candidaturas_curador;
create policy candidaturas_ver_propria on public.candidaturas_curador for select to authenticated
  using (user_id = auth.uid());
drop policy if exists candidaturas_criar on public.candidaturas_curador;
create policy candidaturas_criar on public.candidaturas_curador for insert to authenticated
  with check (user_id = auth.uid() and estado = 'pendente' and public.tem_perfil());

-- =====================================================================
-- Permissões das chaves do site
-- =====================================================================
grant usage on schema public to anon, authenticated;
revoke all on public.perfis, public.salas, public.inscricoes, public.reacoes,
              public.anexos, public.candidaturas_curador from anon, authenticated;

-- Colunas públicas das salas: o autor (autor_id) fica de fora para não ligar propostas a pessoas
grant select (id, slug, pergunta, por_que, esfera, estado, nota_curadoria, sentenca_base, criado_em, atualizado_em)
  on public.salas to anon, authenticated;
grant select on public.anexos to anon;
grant select, insert on public.perfis to authenticated;
grant update (apelido) on public.perfis to authenticated;  -- o papel nunca é alterado pelo próprio usuário
grant insert (pergunta, por_que, esfera, autor_id) on public.salas to authenticated;
grant delete on public.salas to authenticated;
grant update (estado, nota_curadoria, sentenca_base, pergunta, por_que, esfera) on public.salas to authenticated;
grant select, insert, update, delete on public.inscricoes to authenticated;
grant select, insert, delete on public.reacoes to authenticated;
grant select, insert, delete on public.anexos to authenticated;
grant select, insert on public.candidaturas_curador to authenticated;

revoke execute on function public.apagar_minha_conta(), public.definir_papel(uuid, public.papel_t),
  public.listar_candidaturas(), public.decidir_candidatura(uuid, boolean) from public, anon;
grant execute on function public.resumo_salas() to anon, authenticated;
grant execute on function public.minhas_salas() to authenticated;
grant execute on function public.apagar_minha_conta(), public.definir_papel(uuid, public.papel_t),
  public.listar_candidaturas(), public.decidir_candidatura(uuid, boolean),
  public.e_curador(), public.e_admin(), public.tem_perfil() to authenticated;

-- =====================================================================
-- Arquivos anexados (Storage)
-- =====================================================================
insert into storage.buckets (id, name, public)
values ('anexos', 'anexos', true)
on conflict (id) do nothing;

drop policy if exists anexos_storage_curadoria_enviar on storage.objects;
create policy anexos_storage_curadoria_enviar on storage.objects for insert to authenticated
  with check (bucket_id = 'anexos' and public.e_curador());
drop policy if exists anexos_storage_curadoria_apagar on storage.objects;
create policy anexos_storage_curadoria_apagar on storage.objects for delete to authenticated
  using (bucket_id = 'anexos' and public.e_curador());
