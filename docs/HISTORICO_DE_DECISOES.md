# Histórico de decisões — O Pacificador de Famílias

Registro das rodadas de construção do projeto: o que o fundador pediu, o que foi feito e o que ficou pendente. Entradas novas vão no fim; as anteriores não são reescritas.

---

## 18/10/2026 · Rodada 1 — Criação do Conselho (prompt v1.0)

**Pedido do fundador.** Construir um conselho político permanente, a partir de dois conselhos de revisão já usados pelo fundador (um conselho técnico de especialistas e a metodologia LLM Council), para avaliar e confrontar políticos, políticas públicas, leis, PECs, propostas e projetos. Requisitos:
- análise que transcenda esquerda e direita, baseada em métricas, fatos, índices comparáveis, tendências e evolução histórica;
- avaliar as políticas de cada governo, indicar as que comprovadamente deram resultado ou inverteram tendência negativa ou de estagnação, e as principais conquistas;
- separar o que é responsabilidade municipal, estadual e federal;
- identificar interesses e influências geopolíticas, geográficas, econômicas, políticas, diplomáticas, tecnológicas, estratégicas, militares e sociais;
- ser crítico, propositivo, apartidário, sem ego, sem poupar nenhum governo, político ou filósofo, buscando o melhor de cada vertente;
- funcionar como juiz imparcial para mediar debates polarizados, eliminar "torcidas" e formar pensadores críticos.
- Nome proposto pelo fundador: **O Pacificador de Famílias**.

**Feito.** Prompt v1.0 com 15 princípios (régua única, teste do sinal invertido, separação fato/inferência/valor, contrafactual obrigatório, número nunca inventado etc.), escalas oficiais (evidência causal A–E, selos de resultado, evidência de influência I–V, checagem, confiança), instrumentos (matriz federativa, atribuição temporal herança/maré, régua comparável, mapa de forças), 10 cadeiras permanentes, Auditor de Isonomia, Juiz, cadeiras convidadas, protocolo de sessão, protocolo de mediação, estrutura fixa da Sentença, catálogo de fontes e de falácias, templates de subagentes. Template do registro de sentenças.

---

## 18/10/2026 · Rodada 2 — Convocação pelo Juiz, Declaração e entregáveis visuais (prompt v1.1)

**Pedido do fundador.**
1. O número de cadeiras não deve ser fixo: cabe ao Juiz decidir quais convocar e quais chamar excepcionalmente para resolver conflitos; o fundador também pode convocar ou sugerir.
2. Criar uma "Declaração Universal do Pacificador": documento de explicação, comunicação e venda, que proponha a atividade, possa ser compartilhado em grupos de família e atraia participantes abertos a contrariar as próprias "verdades". Sedutor, visualmente elaborado, com infográficos e recursos visuais.
3. Cada rodada deve produzir um documento executivo, rápido e bonito, e uma versão completa, profunda e igualmente visual.

**Feito.** Prompt v1.1 (§5.0 convocação: presenças obrigatórias — Guardião do Método, Cidadão e Auditor —, convocação extraordinária, convocação/sugestão/dispensa pelo usuário, teste da convocação isenta; §9-A entregáveis visuais). Declaração Universal v1.0 em HTML. Modelos de Sentença Executiva e Completa lendo o mesmo JSON, exemplo fictício e gerador.

---

## 18/10/2026 · Rodada 3 — Como estruturar o grupo

**Pedido do fundador.** Propor uma forma viável e simples de criar o grupo: WhatsApp (com o Claude como participante?), página ou site; como organizar discussões e a leitura dos resultados; como viabilizar tecnicamente; como propagar o convite; como tornar a participação fácil.

**Feito.** `PROPOSTA_ESTRUTURA_DO_GRUPO.md`: "o site é a casa, o WhatsApp é a porta, o Claude é o Conselho". O Claude não entra como participante em grupo de WhatsApp; recomendado começar com um humano como porta-voz e avaliar depois um número oficial (API oficial da Meta). Comunidade no WhatsApp com canal de avisos, sala de perguntas e sala de mediação; "Domingo do Pacificador"; site estático com biblioteca de Sentenças; revisão humana por voluntários de lados opostos; propagação pela regra "entre em dupla"; cuidados com LGPD, lei eleitoral e honra.

**Pendente (verificar antes de agir):** suporte atual da API oficial do WhatsApp a grupos e preços; regras do TSE vigentes para conteúdo gerado por IA.

---

## 18/10/2026 · Rodada 4 — Regras da Mesa e motor às claras (prompt v1.2, Declaração v1.1)

**Pedido do fundador.** Estabelecer regras para os participantes, com a regra de ouro:
- ninguém começa uma discussão criticando o outro lado; toda conversa começa por uma proposta de entendimento sobre um tema, política, lei, fato ou resultado controverso;
- nenhum adjetivo qualificador ou pré-conceito ("genocida", "fascista", "nazista", "comunista" e similares) para iniciar ou reduzir a conversa;
- quem se vê sem argumentos não pode reduzir a conversa a julgamento pré-conceituoso do outro lado;
- não vale responder a um erro apontando o mesmo erro do outro lado ("o governo B também roubou");
- quem não estiver disposto a ouvir sem pré-julgamentos e a conhecer fatos e visões contrárias não participa.

Além disso: todo convidado deve conhecer a mecânica, a dinâmica e o prompt do Conselho — o motor, as regras, as instruções e os mandatos — para não haver dúvida sobre como ele mantém a isonomia.

**Feito.** Prompt v1.2: §8-A Regras da Mesa (Regra de Ouro e 10 regras, consequências graduais, como o Conselho as aplica), Verificação de Abertura na mediação, mesa pendente para "o outro lado também". Declaração v1.1 com seção das Regras da Mesa, exemplos de abertura, saídas honrosas, escada de consequências, condição de entrada, resumo das travas de isonomia, compromisso de 7 itens e dois convites. `MOTOR_DO_CONSELHO.html` com o texto integral do prompt embutido por script.

**Decisão do fundador:** a Declaração, as Regras da Mesa, o Motor (com o prompt integral) e as Sentenças circulam entre convidados e participantes. Os demais arquivos ficam de uso interno.

**Pendente:** decidir se o Motor e o prompt também ficam abertos na internet.

---

## 18/10/2026 · Rodada 5 — Repositório próprio

**Pedido do fundador.** Mover todas as discussões, documentos, versões e README para o repositório `pacificador-de-familia`, para que o projeto seja construído e consolidado nele, isolado de outros projetos e de suas restrições.

**Feito.** Todo o conteúdo migrado para este repositório: prompt vigente na raiz, versões anteriores em `historico/`, este histórico de decisões em `docs/`, `CLAUDE.md` próprio do projeto, README novo. Referências a outros repositórios e às regras de confidencialidade deles foram retiradas dos documentos; a política de circulação passou a ser a definida pelo fundador para este projeto (`CLAUDE.md` §4). A pasta foi retirada do repositório de origem, que passou a apontar para este.

---

## 18/10/2026 · Rodada 6 — Repositório público e site sem domínio próprio

**Decisão do fundador.** O repositório `pacificador-de-familia` fica público. A princípio, não haverá domínio próprio para o site.

**Feito.**
- Site preparado para o GitHub Pages, no endereço gratuito https://gutofavero-hash.github.io/Pacificador-de-Familia/: `index.html` (leva à Declaração) e `.nojekyll`.
- Prévias de link para WhatsApp e redes sociais (Open Graph) na Declaração, no Motor e na página de entrada, com imagens próprias em `assets/`. O gerador de Sentenças passou a gravar título, resumo e imagem de prévia em cada Sentença.
- `CLAUDE.md` §4 reescrito: tudo no repositório é público; nunca gravar dado pessoal de participantes, conversas privadas ou credenciais. README com o endereço do site e o passo a passo de ativação. Proposta de estrutura atualizada.

**Concluído no mesmo dia:** repositório tornado público pelo fundador, conteúdo levado à `main` (pull request #1) e GitHub Pages ativado; publicação confirmada pelo GitHub e o site testado pelo fundador.

---

## 18/10/2026 · Rodada 7 — Salas de debate e convocação prática do Conselho

**Pedido do fundador.**
1. Levar a discussão para dentro do site: participantes cadastram temas, os temas abrem salas, e os demais se inscrevem para debater, acompanhar pesquisas e conhecer os resultados.
2. Os responsáveis selecionam o tema e o levam ao Claude para validar a pergunta, validar o tema, submeter ao Conselho e trazer o resultado. Organizar dentro do Claude uma forma fácil, rápida e catalogada de convocar o Conselho para cada tipo de debate.
3. O resultado volta ao site, ligado à sala, automaticamente ou com envio manual de arquivos.
4. Em cada sala, um espaço de opinião: botões (gostei, não gostei, indiferente, neutro) ou textos que passem pelo crivo das Regras da Mesa, com os 5 degraus de regra quebrada.

**Feito.**
- Skills do Claude Code: `/pacificador-validar` (Ficha da Pergunta), `/pacificador-rodada` (rodada completa com pareceres em paralelo, geração dos HTML, registro e texto para os Avisos) e `/pacificador-mediar` (mediação sem gravar nada).
- `CONVOCAR_O_CONSELHO.md`: os três comandos, o fluxo e o cardápio por tipo de debate.
- `projeto-claude-ai/`: kit para criar o Projeto "Pacificador" no app do Claude.
- `docs/PROPOSTA_SALAS_DE_DEBATE.md`: ciclo de vida da sala, arquitetura (site atual + Supabase recomendada), ligação automática Sentença–sala, reações alinhadas à missão no lugar de like e dislike, moderação prévia dos comentários com escada de degraus (3 a 5 só por humano), LGPD e plano em três fases.

**Pendente (decisões do fundador):** opção de arquitetura, forma de login, tipo de reação, momento de abrir comentários em texto, curadores e moderadores. Criar o Projeto no app do Claude.

---

## 18/10/2026 · Rodada 8 — Salas de debate com Supabase (fase 2)

**Decisões do fundador.** Supabase como serviço das salas; login por e-mail sem senha e por conta Google; reações da missão no lugar de like e dislike; comentários em texto só na fase 3; o fundador é o primeiro curador, com inscrições abertas para outros. Pediu todas as orientações e diretrizes para configurar o Supabase.

**Feito.**
- `supabase/schema.sql`: perfis com consentimento LGPD e aceite das Regras da Mesa; salas com ciclo de vida de 9 estados; inscrições com "quero o Conselho"; reações da missão; anexos da curadoria no Storage; candidaturas a curador; políticas de acesso que deixam cada pessoa ver só as próprias inscrições e reações, escondem o autor das salas, impedem autopromoção e só abrem reações após a Sentença; totais públicos anônimos; limite de 5 propostas por dia; apagar a própria conta. Testado em Postgres local com um ambiente que simula o Supabase.
- Páginas `salas.html`, `sala.html`, `curadoria.html` e `privacidade.html`, com o código comum em `assets/` e a configuração pública em `config.js`. Sem configuração, as páginas mostram que as salas estão sendo preparadas.
- Ligação automática entre Sentença e sala pelo `sentencas/indice.json`, mantido pelo gerador.
- `supabase/GUIA_DE_CONFIGURACAO.md` com o passo a passo completo; links para as salas na Declaração; README, CLAUDE.md, guia de convocação e skill de rodada atualizados.

**Pendente (fundador):** seguir o guia de configuração e enviar o Project URL e a chave pública; preencher o e-mail de contato da política de privacidade; revisão da política por profissional de proteção de dados antes da abertura ampla; e-mail próprio (SMTP) antes de convidar muita gente.

---

## 19/10/2026 · Rodada 9 — Convite pelo WhatsApp a partir do site

**Pedido do fundador.** Relembrar todos os meios de convite e inserir no site um botão para convidar novos membros, que já abra o WhatsApp com o convite pronto e o link de cadastro; o mesmo botão dentro de cada sala, para que um participante convide alguém para aquele tema.

**Feito.**
- Botão **Convidar** no topo de salas, sala e curadoria: janela com dois convites (grupo da família e uma pessoa), texto editável, **Enviar pelo WhatsApp** (link `wa.me` com o texto pronto), **Copiar** e, no celular, **Outras formas** (compartilhamento do aparelho).
- Em cada sala, o painel **Convidar para esta sala**, com convite que cita a pergunta da sala e leva direto a ela.
- Os convites levam a `salas.html?convite=1` (ou à sala com `&convite=1`), que mostra uma acolhida com as Regras da Mesa e o botão de entrar.
- Na Declaração, os dois convites passaram a incluir o link de cadastro e ganharam o botão **Enviar pelo WhatsApp**.

**Concluído no mesmo dia (rodada 10):** cartões para o Status e QR code.

---

## 19/10/2026 · Rodada 10 — Cartões para o Status, QR code e cartaz

**Pedido do fundador.** Implementar tudo o que estava proposto para convites e atualizar toda a documentação.

**Feito.**
- `cartao.html`: gera no próprio navegador uma imagem vertical (1080 × 1920) para o Status do WhatsApp, em três versões: convite, sala (`?tipo=sala&s=...`) e Sentença (`?tipo=sentenca&b=...`), cada uma com QR code para o endereço certo. Botões para baixar, compartilhar a imagem (no celular) e copiar a legenda, com instruções de como publicar no Status.
- `cartaz.html`: cartaz A4 com a frase do projeto, as Regras da Mesa em resumo e QR code, pronto para imprimir ou salvar em PDF.
- Nos convites do site: botões **QR code** e **Cartão para o Status**. Na sala, cartão da sala e cartão da Sentença. Na Declaração, links para o cartão e o cartaz. O índice de Sentenças passou a guardar a pergunta para a mesa, usada no cartão.
- Os QR codes foram conferidos decodificando as imagens geradas.
- README, CLAUDE.md, proposta de estrutura e skill de rodada (texto dos Avisos com o link do cartão) atualizados.
