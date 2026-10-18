# Guia de configuração do Supabase

Passo a passo para colocar as salas de debate no ar. Leva cerca de 40 minutos, uma vez só. As telas do Supabase e do Google mudam com frequência: se um nome de botão estiver diferente, procure o equivalente na mesma área.

## O que você vai precisar

- Uma conta Google (a mesma que você usa no dia a dia serve).
- Este repositório no GitHub (já existe).
- Nada de cartão de crédito: tudo usa planos gratuitos.

## Visão geral

| Etapa | Onde | Tempo |
|---|---|---|
| 1. Criar o projeto | supabase.com | 5 min |
| 2. Criar o banco de dados | Supabase → SQL Editor | 3 min |
| 3. Configurar os endereços do site | Supabase → Authentication | 3 min |
| 4. Ativar o login por e-mail | Supabase → Authentication | 2 min |
| 5. Ativar o login com Google | Google Cloud + Supabase | 15 min |
| 6. Ligar o site ao Supabase | Supabase → API, e o arquivo `config.js` | 5 min |
| 7. Tornar-se administrador | Supabase → SQL Editor | 2 min |
| 8. Testar | O site | 5 min |

---

## 1 · Criar o projeto

1. Acesse **supabase.com** e clique em **Start your project**. Entre com a sua conta do GitHub ou do Google.
2. Crie uma organização, se ele pedir. Nome: `Pacificador de Famílias`. Plano: **Free**.
3. Clique em **New project** e preencha:
   - **Name:** `pacificador-de-familia`
   - **Database Password:** clique em **Generate a password** e **guarde a senha num lugar seguro**, como um gerenciador de senhas. Ela não vai para o site nem para o repositório.
   - **Region:** **South America (São Paulo)**. Os dados ficam no Brasil, o que ajuda com a LGPD.
4. Clique em **Create new project** e espere de 1 a 2 minutos.

> **Atenção ao plano gratuito:** projetos gratuitos podem ser pausados depois de alguns dias sem nenhum acesso. Se isso acontecer, basta entrar no painel e clicar em **Restore**. Confira as regras atuais na página de preços do Supabase.

## 2 · Criar o banco de dados

1. No menu da esquerda, abra **SQL Editor** e clique em **New query**.
2. Abra o arquivo `supabase/schema.sql` deste repositório, no GitHub. Clique em **Raw** e copie todo o conteúdo.
3. Cole no SQL Editor e clique em **Run**.
4. Deve aparecer **Success. No rows returned**.
5. Confira em **Table Editor**: devem existir as tabelas `perfis`, `salas`, `inscricoes`, `reacoes`, `anexos` e `candidaturas_curador`. Em **Storage**, deve existir o bucket `anexos`.

O arquivo pode ser rodado de novo sem perder dados. Faça isso sempre que ele for atualizado no repositório.

## 3 · Configurar os endereços do site

1. Abra **Authentication → URL Configuration**.
2. **Site URL:** `https://gutofavero-hash.github.io/Pacificador-de-Familia/salas.html`
3. Em **Redirect URLs**, clique em **Add URL** e adicione:
   `https://gutofavero-hash.github.io/Pacificador-de-Familia/**`
4. Salve.

Isso garante que, depois do login, a pessoa volte para a página onde estava.

## 4 · Ativar o login por e-mail (sem senha)

1. Abra **Authentication → Sign In / Providers** (em algumas versões: **Providers**).
2. Em **Email**, deixe **ativado**. O site usa o link mágico: a pessoa digita o e-mail e recebe um link de acesso, sem senha.
3. Opcional, recomendado: em **Authentication → Emails** (ou **Email Templates**), abra o modelo **Magic Link** e troque o texto para português, por exemplo:
   - **Assunto:** `Seu link de acesso ao Pacificador de Famílias`
   - **Corpo:** `Olá! Toque no link abaixo para entrar nas salas de debate do Pacificador de Famílias. Se você não pediu este acesso, ignore esta mensagem.` Mantenha o trecho com `{{ .ConfirmationURL }}`, que é o link.

> **Limite de e-mails:** o serviço de e-mail embutido do Supabase envia poucas mensagens por hora e serve para testes. Antes de convidar muita gente, configure um serviço de e-mail próprio em **Authentication → Emails → SMTP Settings**. Resend e Brevo, por exemplo, têm planos gratuitos. Posso ajudar nisso quando chegar a hora.

## 5 · Ativar o login com Google

### 5.1 No Google Cloud

1. Acesse **console.cloud.google.com** e entre com a sua conta Google.
2. No topo, clique no seletor de projetos e depois em **Novo projeto**. Nome: `Pacificador de Famílias`. Clique em **Criar**.
3. Com o projeto selecionado, abra **APIs e serviços → Tela de consentimento OAuth**. Em algumas versões, o caminho é **Google Auth Platform → Branding**.
   - **Tipo de usuário:** **Externo**.
   - **Nome do app:** `O Pacificador de Famílias`.
   - **E-mail de suporte:** o seu.
   - **Link da política de privacidade:** `https://gutofavero-hash.github.io/Pacificador-de-Familia/privacidade.html`. Se o Google pedir para verificar o domínio desse link e travar o avanço, deixe o campo em branco por enquanto.
   - **E-mail de contato do desenvolvedor:** o seu.
   - **Escopos:** não acrescente nada. O login usa só os básicos (e-mail e perfil), que não exigem verificação.
   - Ao final, em **Público-alvo** ou **Status de publicação**, clique em **Publicar app**. Enquanto estiver em **Teste**, só os e-mails cadastrados como testadores conseguem entrar.
4. Abra **APIs e serviços → Credenciais** (ou **Google Auth Platform → Clients**) e clique em **Criar credenciais → ID do cliente OAuth**.
   - **Tipo de aplicativo:** **Aplicativo da Web**.
   - **Nome:** `Pacificador — Supabase`.
   - **Origens JavaScript autorizadas:** `https://gutofavero-hash.github.io`
   - **URIs de redirecionamento autorizados:** o endereço de retorno que o Supabase mostra no passo 5.2, no formato `https://SEU-PROJETO.supabase.co/auth/v1/callback`.
   - Clique em **Criar**. Copie o **ID do cliente** e a **Chave secreta do cliente**.

### 5.2 No Supabase

1. Abra **Authentication → Sign In / Providers → Google**.
2. Copie o **Callback URL (for OAuth)** que aparece ali e cole no campo "URIs de redirecionamento autorizados" do Google (passo 5.1, item 4).
3. Ative o **Google**, cole o **Client ID** e o **Client Secret** do Google e salve.

> A chave secreta do Google fica **só** no painel do Supabase. Não a envie por mensagem, não a cole no site nem no repositório.

## 6 · Ligar o site ao Supabase

1. No Supabase, abra **Project Settings → Data API**. Em algumas versões, o caminho é **Project Settings → API**. Copie:
   - o **Project URL**, como `https://abcdefgh.supabase.co`;
   - a chave pública, que pode aparecer como **anon public** ou como **publishable key** (começa com `sb_publishable_`). Esta e a do item anterior são as únicas que vão para o site.
2. **Nunca** copie a chave **service_role** nem a **secret key**. Elas dão acesso total ao banco e nunca podem ir para o site nem para o repositório.
3. Envie os dois valores para mim numa sessão do Claude Code, e eu atualizo o `config.js`. Se preferir fazer você mesmo:
   1. abra `config.js` no GitHub e clique no lápis (**Edit**);
   2. preencha `supabaseUrl` e `supabaseAnonKey`;
   3. clique em **Commit changes** direto na `main`.

   O site atualiza em poucos minutos.

> Por que a chave pública pode ficar no site: ela só consegue fazer o que as regras do banco (`supabase/schema.sql`) permitem. Cada pessoa só vê as próprias inscrições e reações, só a curadoria muda o estado das salas, e ninguém se promove sozinho.

## 7 · Tornar-se administrador

1. Abra `https://gutofavero-hash.github.io/Pacificador-de-Familia/salas.html`, clique em **Entrar**, entre com o seu e-mail ou com o Google, escolha um apelido e aceite os dois termos.
2. No Supabase, abra **SQL Editor → New query**, cole o comando abaixo, troque o e-mail pelo que você usou para entrar e clique em **Run**:

```sql
update public.perfis set papel = 'admin'
where id = (select id from auth.users where email = 'SEU-EMAIL-AQUI');
```

3. Recarregue o site. O link **Curadoria** aparece no topo.

Novos curadores se candidatam pelo próprio site, em **Minha conta → Quero ser curador**. Você aprova ou recusa em **Curadoria → Candidaturas a curador**.

## 8 · Testar

| Teste | Resultado esperado |
|---|---|
| Entrar com e-mail | Chega o link; ao tocar, você volta logado às salas |
| Entrar com Google | Volta logado às salas |
| Propor um tema | Aparece em "Minhas propostas" como **Proposta** e na Curadoria, aba **Entrada** |
| Abrir a sala | Na Curadoria, mude o estado para **Aberta** e salve; a sala aparece para todos |
| Inscrever-se | Em outra conta ou janela anônima: o total de inscritos aumenta |
| Reações | Só funcionam depois de mudar a sala para **Sentença publicada** |
| Anexo | Na Curadoria, anexe um PDF; ele aparece em "Materiais da sala" |
| Apagar conta | Em **Minha conta → Apagar minha conta**; o login e as reações somem |

## 9 · Ligar uma Sentença à sala

1. Na Curadoria, use **Copiar comando da rodada**. Ele já vem com o identificador da sala (`— sala: ...`).
2. Cole no Claude Code. A Sentença é gerada com o campo `sala`, e o `sentencas/indice.json` é atualizado automaticamente.
3. Depois da revisão humana, peça **"publica a Sentença S-nnn"**. Quando chegar à `main`, a Sentença aparece sozinha dentro da sala.
4. Na Curadoria, mude o estado da sala para **Sentença publicada**. Isso abre as reações.

## Antes de abrir para muita gente

- [ ] Preencher o e-mail de contato em `privacidade.html` (seção 1).
- [ ] Revisão da política de privacidade por um profissional de proteção de dados.
- [ ] E-mail próprio (SMTP) configurado no Supabase.
- [ ] App do Google publicado, não em modo de teste.
- [ ] Ao menos 2 curadores além de você.
