---
documento: PROPOSTA_ESTRUTURA_DO_GRUPO
versao: 1.0
data: 2026-10-18
status: Proposta para decisão do fundador
projeto: O Pacificador de Famílias
circulacao: Documento interno de planejamento (não circula entre participantes).
---

# Como estruturar o grupo do Pacificador de Famílias

## A recomendação em uma frase

**O site é a casa, o WhatsApp é a porta, e o Claude é o Conselho.** As Sentenças moram num site simples (cada uma com seu link). As pessoas chegam, recebem e conversam pelo WhatsApp, onde já estão. As rodadas são executadas no Claude, com o prompt do Conselho, e passam por uma revisão humana antes de publicar.

```
      ┌──────────────────────── ENTRADA ────────────────────────┐
      │  Enquete no WhatsApp · formulário no site · mensagem 1:1 │
      └───────────────────────────┬─────────────────────────────┘
                                  ▼
               Curadoria semanal escolhe 1 ou 2 temas
                                  ▼
      Rodada no Claude (prompt do Conselho) ──► JSON da Sentença
                                  ▼
            gerar_sentenca.py ──► Executiva + Completa (HTML)
                                  ▼
       Revisão humana de isonomia (2 a 3 voluntários de lados opostos)
                                  ▼
   Site (biblioteca de Sentenças)  ◄──►  Canal de avisos no WhatsApp
                                  ▼
          Conversa nas "mesas": grupos das famílias e sala de mediação
```

## 1. Posso ser um participante do grupo de WhatsApp?

**Não diretamente, e é importante dizer isso com clareza.** O Claude não tem conta de WhatsApp e não consegue entrar num grupo comum como uma pessoa. Há três caminhos, do mais simples ao mais técnico:

| Caminho | Como funciona | Prós | Contras |
|---|---|---|---|
| **A. Humano como porta-voz** (recomendado para começar) | Você (ou um moderador) leva a pergunta ao Claude, roda o Conselho e publica a Sentença no grupo | Custo zero, começa hoje, revisão humana embutida, sem risco de banimento | Depende de alguém para operar; não é instantâneo |
| **B. Número oficial do Pacificador** (fase 2) | Um número de WhatsApp Business ligado à API oficial da Meta (Cloud API) e ao Claude. A pessoa conversa 1:1 com o número: "pacificador checa: [frase]" e recebe a resposta e o link da Sentença | Atende qualquer pessoa a qualquer hora; escala | Exige desenvolvimento, custo por mensagem da Meta e da API do Claude; o suporte da API oficial a grupos é limitado e precisa ser verificado na documentação atual da Meta antes de prometer presença em grupos |
| **C. Bot em grupo no Telegram** | O Telegram permite bots dentro de grupos nativamente e de graça | O Claude "participa" de fato da conversa | As famílias brasileiras estão no WhatsApp, não no Telegram |

**O que evitar:** bibliotecas não oficiais que "simulam" um celular para colocar um robô em grupos de WhatsApp. Elas violam os termos da Meta, o número pode ser banido e os dados ficam expostos.

## 2. A estrutura recomendada

### 2.1 No WhatsApp: uma Comunidade

O WhatsApp tem o recurso **Comunidades**, que agrupa vários grupos sob um mesmo nome e inclui um canal de avisos. É exatamente o formato de que precisamos:

| Espaço | Para quê | Quem escreve |
|---|---|---|
| **Avisos do Pacificador** (canal da Comunidade) | Toda Sentença nova: 3 linhas de resumo, o link da Executiva e a pergunta para a mesa de jantar | Só moderadores |
| **Sala de Perguntas** | Membros sugerem temas; toda semana uma enquete escolhe o próximo | Todos |
| **Sala de Mediação** | Debate moderado sobre a Sentença da semana, com as regras do compromisso | Todos, com moderação |
| **Mesas de família** (opcional) | Cada família pode criar seu próprio grupo dentro da Comunidade e ler as Sentenças juntas | A família |

Ritual sugerido: **o "Domingo do Pacificador"**. Uma Sentença por semana, publicada no domingo de manhã, para ser lida antes do almoço de família. Uma cadência fixa cria hábito e evita sobrecarga.

### 2.2 O site: a biblioteca

Um site estático, gratuito para hospedar (GitHub Pages, Cloudflare Pages ou Netlify), com:

1. **Página inicial**: a Declaração Universal (já pronta).
2. **Biblioteca de Sentenças**: cada rodada com sua Executiva e sua Completa (geradas pelo `modelos/gerar_sentenca.py`), filtrável por tema, esfera (municipal, estadual, federal) e tipo (política, lei, checagem, governo).
3. **Envie sua pergunta**: um formulário simples (Google Forms ou Tally, no início).
4. **Como funcionamos**: o `MOTOR_DO_CONSELHO.html`, com o método, os mandatos e o texto integral do prompt (decisão do fundador de 18/10/2026: todo convidado e participante conhece o motor), e as Regras da Mesa da Declaração.

Cada Sentença ganha um link próprio. Quando colado no WhatsApp, o link mostra uma prévia com título, resumo e imagem: as páginas e o gerador de Sentenças já incluem esses metadados (Open Graph).

**Decidido (18/10/2026):** o repositório `pacificador-de-familia` é público e o site sai dele pelo GitHub Pages, sem domínio próprio: https://gutofavero-hash.github.io/Pacificador-de-Familia/. A divulgação nos grupos aponta para a Declaração, o Motor e as Sentenças; os demais arquivos ficam acessíveis no repositório, mas não são divulgados ativamente.

### 2.3 O Claude: onde o Conselho roda

| Fase | Onde | Como |
|---|---|---|
| 1 | **Projeto no claude.ai** com o prompt do Conselho como instrução do projeto e a busca na web ativada | Você cola a pergunta e recebe a Sentença e o JSON; roda o `gerar_sentenca.py` para obter os dois HTML |
| 2 | **Claude Code** neste repositório | As cadeiras rodam como subagentes paralelos de verdade (cada cadeira como um subagente), e o resultado é gravado direto em `sentencas/` |
| 3 | **Serviço próprio** (Claude API + Agent SDK + uma função serverless) ligado ao número oficial do WhatsApp | Pergunta 1:1 → rodada automática → fila de revisão humana → publicação no site e no canal |

## 3. A revisão humana: o que dá credibilidade

Antes de publicar, toda Sentença passa por um **Comitê de Isonomia humano**: duas ou três pessoas voluntárias, de preferências políticas declaradamente opostas, com 24 horas para apontar viés. Elas não reescrevem o mérito: só podem devolver para nova rodada, com o motivo registrado. Isso faz três coisas:

1. pega erros que a IA deixou passar;
2. dá aos participantes a certeza de que "alguém do meu lado" olhou;
3. cria um papel nobre para os membros mais engajados.

## 4. Como o convite se espalha

1. **A regra de entrada é o motor:** "traga alguém que pensa diferente de você". Cada membro entra em dupla. Isso faz o grupo crescer e garante a diversidade ao mesmo tempo.
2. **Padrinhos e madrinhas:** cada membro que convidou alguém do outro lado acompanha a primeira conversa dessa pessoa.
3. **Kit de convite** (parte já pronta na Declaração): o texto para o grupo da família com botão de copiar, o link da Declaração e um QR code para quem convida pessoalmente.
4. **Cartões para o Status do WhatsApp:** uma imagem vertical por Sentença, com o veredicto, um achado e a pergunta para a mesa. É o formato que mais circula entre famílias. Pode ser gerado automaticamente a partir do mesmo JSON (próximo passo técnico).
5. **Começar pequeno e de propósito:** 5 a 10 famílias convidadas por você, de perfis diferentes, por 4 semanas. Só depois abrir. Uma comunidade que começa com a cultura certa a mantém.

## 5. Como tornar fácil participar

- **Zero cadastro, zero aplicativo novo.** Basta entrar na Comunidade do WhatsApp e abrir links.
- **Dois minutos por semana são suficientes.** A Executiva é feita para ler no celular, entre uma coisa e outra.
- **Uma pergunta por semana, não um fluxo infinito.** O ritmo fixo evita a fadiga que destrói grupos.
- **Três formas de perguntar:** enquete, formulário ou mensagem a um moderador.
- **Linguagem do Cidadão em tudo** que vai para o grupo.

## 6. Cuidados que não são opcionais

| Tema | Por quê | O que fazer |
|---|---|---|
| **LGPD** | Opinião política é **dado pessoal sensível** (Lei 13.709/2018, art. 5º, II, e art. 11) | Não guardar a opinião de ninguém vinculada à identidade; o teste da Declaração já não envia nada. Se houver formulário, pedir consentimento explícito e coletar o mínimo |
| **Lei eleitoral** | As regras do TSE para propaganda e para conteúdo gerado por IA se intensificam no período eleitoral, e a Resolução TSE 23.732/2024 exige rotular conteúdo feito com IA | Toda Sentença traz o aviso "análise gerada por IA, com revisão humana". Evitar perfis de candidatos durante o período eleitoral. Consultar um advogado eleitoral antes de abrir ao público |
| **Honra e reputação** | O modo "perfil de político" pode gerar acusação de calúnia ou difamação | Revisão humana obrigatória; estado processual exato (princípio 13 do prompt) |
| **Documentos internos** | Proposta, registro e modelos não são material de circulação | Publicar no site só a Declaração, o Motor e as Sentenças |
| **Percepção de lado** | Um único deslize vira "o Pacificador é de esquerda" ou "é de direita" | Comitê humano de isonomia, prompt publicado, canal de correções visível |

## 7. Plano de implantação

| Quando | O quê | Custo |
|---|---|---|
| **Semana 1** | Criar o Projeto no claude.ai com o prompt; rodar 3 Sentenças-piloto de temas de esferas diferentes; recrutar 2 a 3 revisores de isonomia | Plano Claude que você já usa |
| **Semana 2** | Criar a Comunidade no WhatsApp; publicar a Declaração e as 3 Sentenças no site do GitHub Pages; convidar as primeiras 5 a 10 famílias | Sem custo (GitHub Pages, sem domínio próprio) |
| **Semanas 3 a 6** | Domingo do Pacificador semanal; coletar o que funciona; medir quantas duplas se formaram e quantas pessoas relatam ter reconhecido um acerto do outro lado | — |
| **Mês 2 em diante** | Se a cultura pegou: cartões para Status, automação no Claude Code, avaliação do número oficial do WhatsApp | Custos de API da Meta e do Claude, a orçar com uso real |

**Indicador de sucesso principal:** pessoas que dizem "reconheci um acerto do lado que eu criticava". É a missão em forma de número, e deve ser coletado de forma anônima.

## 8. Decisões que são suas

1. ~~Publicar ou não o prompt do Conselho~~ — decidido em 18/10/2026: o motor e o texto integral circulam entre todos os convidados e participantes. Falta decidir se também ficam abertos na internet.
2. ~~Criar o repositório, torná-lo público e decidir o domínio~~ — decidido: repositório público, site no GitHub Pages, sem domínio próprio por enquanto.
3. Quem são as primeiras 5 a 10 famílias e os 2 a 3 revisores de isonomia.
4. Começar agora ou depois do segundo turno eleitoral.
