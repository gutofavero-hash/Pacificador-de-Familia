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
- Site preparado para o GitHub Pages, no endereço gratuito https://gutofavero-hash.github.io/pacificador-de-familia/: `index.html` (leva à Declaração) e `.nojekyll`.
- Prévias de link para WhatsApp e redes sociais (Open Graph) na Declaração, no Motor e na página de entrada, com imagens próprias em `assets/`. O gerador de Sentenças passou a gravar título, resumo e imagem de prévia em cada Sentença.
- `CLAUDE.md` §4 reescrito: tudo no repositório é público; nunca gravar dado pessoal de participantes, conversas privadas ou credenciais. README com o endereço do site e o passo a passo de ativação. Proposta de estrutura atualizada.

**Pendente (ação do fundador no GitHub):** tornar o repositório público (Settings → General → Danger Zone → Change visibility), levar o conteúdo para a `main` e ativar o Pages (Settings → Pages → Deploy from a branch → `main`, `/ (root)`).
