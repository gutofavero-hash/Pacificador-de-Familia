-- Cenários de acesso das salas. Linhas marcadas 'deve falhar' precisam terminar em ERROR ou em 0 linhas.
\set ON_ERROR_STOP 0
insert into auth.users values ('00000000-0000-0000-0000-00000000000a','admin@x'),('00000000-0000-0000-0000-00000000000b','b@x'),('00000000-0000-0000-0000-00000000000c','c@x');
-- usuário B: cria perfil e propõe
set role authenticated; set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000b';
insert into public.salas(pergunta,autor_id) values ('Quero entender por que os homicídios caíram no Brasil?','00000000-0000-0000-0000-00000000000b'); -- deve falhar: sem perfil
insert into public.perfis(id,apelido,consentimento_em,regras_aceitas_em,papel) values ('00000000-0000-0000-0000-00000000000b','Bia',now(),now(),'admin'); -- deve falhar: papel
insert into public.perfis(id,apelido,consentimento_em,regras_aceitas_em) values ('00000000-0000-0000-0000-00000000000b','Bia',now(),now());
update public.perfis set papel='admin' where id=auth.uid(); -- deve falhar: sem permissão de coluna
insert into public.salas(pergunta,autor_id,esfera) values ('Quero entender por que os homicídios caíram no Brasil desde 2018?','00000000-0000-0000-0000-00000000000b','varias') returning slug, estado;
insert into public.salas(pergunta,autor_id,estado) values ('Quero entender outra coisa importante aqui','00000000-0000-0000-0000-00000000000b','aberta'); -- deve falhar: estado
update public.salas set estado='aberta'; -- 0 linhas (não é curador)
select count(*) as salas_visiveis_b from public.salas;
reset role;
-- anon não vê proposta
reset request.jwt.claim.sub; set role anon; select count(*) as anon_ve from public.salas; select * from public.resumo_salas(); reset role;
-- admin
insert into public.perfis(id,apelido,consentimento_em,regras_aceitas_em,papel) values ('00000000-0000-0000-0000-00000000000a','Guto',now(),now(),'admin');
set role authenticated; set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000a';
select public.e_curador() as admin_curador;
update public.salas set estado='aberta', nota_curadoria='Validada.' returning slug, estado;
update public.salas set slug='hack' ; -- deve falhar: sem permissão de coluna
reset role;
reset request.jwt.claim.sub; set role anon; select count(*) as anon_ve_aberta from public.salas; reset role;
-- C: perfil, inscreve, tenta reagir antes da publicação
set role authenticated; set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000c';
insert into public.perfis(id,apelido,consentimento_em,regras_aceitas_em) values ('00000000-0000-0000-0000-00000000000c','Caio',now(),now());
insert into public.inscricoes(sala_id,user_id,quer_conselho) select id, auth.uid(), true from public.salas;
insert into public.reacoes(sala_id,user_id,tipo) select id, auth.uid(), 'aprendi' from public.salas; -- deve falhar: não publicada
select count(*) as c_ve_inscricoes from public.inscricoes;
select count(*) as c_ve_perfis from public.perfis;
insert into public.candidaturas_curador(user_id,motivacao) values (auth.uid(),'Quero ajudar a curar os temas com isonomia.');
select * from public.listar_candidaturas(); -- vazio (não admin)
insert into storage.objects(bucket_id,name) values ('anexos','x.pdf'); -- deve falhar
reset role;
set role authenticated; set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000a';
update public.salas set estado='publicada', sentenca_base='2026-10-20_S-001_homicidios';
select apelido, estado from public.listar_candidaturas();
select public.decidir_candidatura((select id from public.listar_candidaturas() limit 1), true);
insert into storage.objects(bucket_id,name) values ('anexos','x.pdf');
insert into public.anexos(sala_id,titulo,caminho,enviado_por) select id,'Dossiê','x.pdf',auth.uid() from public.salas;
reset role;
set role authenticated; set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000c';
select public.e_curador() as c_agora_curador;
insert into public.reacoes(sala_id,user_id,tipo) select id, auth.uid(), 'reconheco' from public.salas;
insert into public.reacoes(sala_id,user_id,tipo) select id, '00000000-0000-0000-0000-00000000000b', 'mudei' from public.salas; -- deve falhar: outro usuário
reset role;
reset request.jwt.claim.sub; set role anon; select inscritos, querem_conselho, reconheco from public.resumo_salas(); select count(*) anexos_publicos from public.anexos; select count(*) from public.reacoes; reset role;
-- spam: B propõe mais 5
set role authenticated; set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000b';
insert into public.salas(pergunta,autor_id) select 'Quero entender o tema número '||g||' agora mesmo', auth.uid() from generate_series(1,5) g; -- deve falhar no 5º (já tem 1)
select public.apagar_minha_conta();
reset role;
select count(*) as perfis_restantes from public.perfis; select count(*) salas_sem_autor from public.salas where autor_id is null;
-- colunas: anon não lê autor_id; usuário vê as próprias via função
reset request.jwt.claim.sub; set role anon; select autor_id from public.salas; select slug, estado from public.salas; reset role;
set role authenticated; set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000c';
insert into public.salas(pergunta,autor_id) values ('Quero entender o efeito do programa Z na renda','00000000-0000-0000-0000-00000000000c') returning slug;
select pergunta, estado from public.minhas_salas();
select autor_id from public.salas; -- deve falhar
reset role;
