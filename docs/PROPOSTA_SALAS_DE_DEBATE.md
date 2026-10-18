---
documento: PROPOSTA_SALAS_DE_DEBATE
versao: 1.0
data: 2026-10-18
status: Proposta para decisão do fundador
---

# Salas de debate no site

Proposta para levar a conversa do WhatsApp para dentro do site: temas cadastrados pelos participantes abrem salas, as pessoas se inscrevem, o Conselho julga e o resultado volta para a sala, onde os inscritos reagem e comentam sob as Regras da Mesa.

## A recomendação em uma frase

**O WhatsApp continua sendo a porta (avisos e convites), e o site passa a ser a casa da conversa.** As salas, as inscrições, os arquivos e os comentários moram no site; o WhatsApp só avisa "abriu a sala X" e "saiu a Sentença da sala X".

## 1 · O ciclo de vida de uma sala

```
PROPOSTA ──► EM VALIDAÇÃO ──► ABERTA ──► NO CONSELHO ──► EM REVISÃO ──► SENTENÇA PUBLICADA ──► EM DEBATE ──► ARQUIVADA
   │              │              │             │               │                 │                  │
participante   curador roda   inscrições,   /pacificador-   revisores de     arquivos ligados    reações e
cadastra o     /pacificador-  enquete de    rodada          isonomia         à sala              comentários
tema           validar        prioridade                                                         moderados
```

| Estado | Quem age | O que acontece |
|---|---|---|
| Proposta | Qualquer participante | Cadastra o tema num formulário que já pede o formato "Quero entender…" |
| Em validação | Curador | Roda `/pacificador-validar`; aprova, pede reformulação ou recusa com motivo |
| Aberta | Participantes | Inscrevem-se na sala e marcam "quero que vá ao Conselho"; o curador vê quais salas têm mais interesse |
| No Conselho | Curador / operador | Roda `/pacificador-rodada [modo]: [pergunta] — sala: [id]` |
| Em revisão | Revisores de isonomia | Conferem a Sentença em 24 h |
| Sentença publicada | Automático | A Sentença aparece dentro da sala; inscritos são avisados |
| Em debate | Inscritos | Reagem e comentam sob as Regras da Mesa |
| Arquivada | Curador | A sala fica de leitura; o gatilho de revisão pode reabri-la |

## 2 · O que o site atual consegue e o que não consegue

O site de hoje (GitHub Pages) é **estático**: mostra páginas, mas não guarda cadastro, inscrição, reação nem comentário. Para as salas é preciso um serviço que guarde dados e identifique as pessoas.

| Opção | Como funciona | Prós | Contras | Avaliação |
|---|---|---|---|---|
| **A. Site atual + Supabase** | O site continua no GitHub Pages; um serviço de banco de dados com login (Supabase, plano gratuito) guarda salas, inscrições, reações, comentários e arquivos | Custo zero no começo; login por e-mail sem senha ou por conta Google; tudo sob controle do projeto; permite moderação automática | Exige desenvolvimento (estimativa: algumas sessões de trabalho) e um responsável técnico | **Recomendada** |
| B. GitHub Discussions | Fórum embutido no próprio repositório | Pronto e gratuito | Exige conta no GitHub: barreira alta para famílias | Não recomendada |
| C. Fórum pronto (Discourse, Circle e similares) | Plataforma de comunidade contratada | Pronto para usar | Custo mensal; pouca personalização das Regras da Mesa e da moderação | Alternativa se não houver quem desenvolva |

## 3 · Como cada pedido seria atendido (opção A)

### 3.1 Cadastro de temas e salas
- Formulário com três campos: **"Quero entender…"** (obrigatório, com o exemplo da Regra de Ouro ao lado), **por que isso importa** e **esfera, se souber** (município, estado, União).
- Antes de enviar, uma checagem automática simples avisa se o texto parece acusação ou traz rótulo, e sugere reformular. A validação de verdade continua com o curador e o `/pacificador-validar`.

### 3.2 Levar ao Claude (já pronto)
- O curador copia a pergunta da sala e roda no Claude Code: `/pacificador-validar` e depois `/pacificador-rodada ... — sala: [id]`.
- Ver `CONVOCAR_O_CONSELHO.md`.

### 3.3 O resultado volta para a sala
- **Automático (recomendado):** a Sentença é gerada em `sentencas/` já com o campo `sala`. Quando vai para a `main`, o site lista a Sentença dentro da sala correspondente. Nada para carregar à mão, e a Sentença fica versionada e pública no repositório.
- **Manual (complemento):** cada sala tem uma área de anexos, com envio permitido só a curadores e operadores, para materiais extras (apresentações, PDFs, a mediação de uma conversa sem nomes).

### 3.4 Opiniões na sala

**Reações: sugiro trocar like e dislike por reações que reforcem a missão.** Curtir e não curtir vira placar, e placar vira torcida, exatamente o que o Pacificador quer desmontar. Proposta:

| Reação | Significado |
|---|---|
| 💡 Aprendi algo | A Sentença trouxe um fato que eu não conhecia |
| 🔄 Mudei de ideia em algo | Revi alguma posição minha |
| 🤝 Reconheço um acerto do outro lado | O indicador central da missão |
| 🔍 Quero mais dados | Ficou uma lacuna que merece nova rodada |
| ⚖️ Discordo, e sei explicar por quê | Discordância qualificada; abre o campo de comentário |

O site mostra os totais de forma agregada e anônima, nunca quem reagiu como.

**Comentários em texto, com as Regras da Mesa aplicadas antes de publicar:**
1. **Resumo antes de rebater (Regra 6):** para responder a alguém, a pessoa primeiro escreve, em uma frase, o que entendeu da posição do outro.
2. **Moderação prévia automática:** ao clicar em "publicar", o texto passa por uma checagem com o Claude (via API) contra as Regras da Mesa: rótulos, acusação ao outro lado, "o outro também", deboche, dado pessoal de terceiros.
3. **Se passar,** publica na hora.
4. **Se não passar,** o comentário **não é publicado** e a pessoa recebe, só para ela, o **degrau 1 (lembrete gentil)**: qual regra foi tocada e uma sugestão de reformulação. Ela pode editar e reenviar.
5. **Insistência gera os degraus seguintes**, registrados por pessoa:
   - degrau 2, **pausa**: a pessoa fica algumas horas sem comentar naquela sala;
   - degraus 3 a 5, **conversa privada, afastamento temporário e saída**: decididos sempre por um moderador humano. A IA sinaliza, mas não expulsa ninguém sozinha.
6. **Recurso:** quem discordar da checagem automática pede revisão humana com um clique.

## 4 · Cuidados que pesam mais aqui do que no resto do projeto

| Tema | Por quê | O que fazer |
|---|---|---|
| **LGPD** | Inscrição em sala, reação e comentário sobre política revelam **opinião política, dado pessoal sensível** (Lei 13.709/2018, art. 5º, II, e art. 11) | Consentimento explícito no cadastro; política de privacidade; apelido em vez de nome real; reações só agregadas; direito de apagar a conta e os comentários; dados guardados no serviço, nunca no repositório público |
| **Moderação por IA** | Erro da IA pode censurar um comentário legítimo | A IA só retém e sugere; publicar depois de editar é sempre possível; degraus 3 a 5 só por humano; recurso com um clique |
| **Lei eleitoral** | Comentários sobre candidatos em período eleitoral | Regras do TSE a verificar com advogado antes de abrir; moderação mais estrita no período |
| **Responsabilidade pelo conteúdo** | Comentário ofensivo publicado é responsabilidade de quem mantém o site | Moderação prévia, canal de denúncia, termos de uso |
| **Custo** | Cada checagem de comentário consome a API do Claude | Usar um modelo pequeno e barato para a checagem; orçar com o volume real |

## 5 · Plano em fases

| Fase | O que entra | Precisa de |
|---|---|---|
| **1 · Já** | Comandos do Conselho no Claude Code e kit do Projeto no app (feito); página "Salas" de leitura no site, gerada a partir do repositório, mostrando cada tema, seu estado e sua Sentença; cadastro de temas por formulário simples | Nada além do que existe |
| **2 · Salas com login** | Conta no Supabase; login por e-mail sem senha ou Google; cadastro de temas, inscrição em salas, reações da missão, anexos de curadores, Sentença ligada à sala automaticamente; aviso por e-mail ou WhatsApp quando sai a Sentença | Conta gratuita no Supabase criada pelo fundador; política de privacidade e termos de uso |
| **3 · Fórum moderado** | Comentários com "resumo antes de rebater", moderação prévia pelo Claude, escada de 5 degraus por pessoa, recurso, painel do moderador | Chave da API do Claude guardada no serviço (nunca no repositório); orçamento de uso |

## 6 · Decisões que são do fundador

1. Seguir com a opção A (site + Supabase) ou contratar um fórum pronto.
2. Forma de login: e-mail sem senha, conta Google, ou as duas.
3. Trocar like e dislike pelas reações da missão (recomendado) ou manter os botões pedidos.
4. Abrir comentários em texto já na fase 2 ou só na fase 3, com a moderação pronta.
5. Quem são os curadores e moderadores humanos.
