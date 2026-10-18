# O Pacificador de Famílias

Conselho Político Permanente: um tribunal de evidências para avaliar e confrontar políticos, governos, políticas públicas, leis, PECs, PLs, MPs, propostas e projetos, em qualquer esfera, com a mesma régua para todos, e para mediar conversas polarizadas entre pessoas reais.

> Antes de escolher um lado, escolha os fatos.

Criado em 18/10/2026 por Augusto Silveira Fávero. Projeto independente e público: tudo o que diz respeito ao Pacificador é construído e consolidado neste repositório.

**Site:** https://gutofavero-hash.github.io/Pacificador-de-Familia/

## Por onde começar

| Se você é… | Abra |
|---|---|
| Convidado ou participante | `DECLARACAO_UNIVERSAL_DO_PACIFICADOR.html` (o convite e as Regras da Mesa) e depois `MOTOR_DO_CONSELHO.html` (como o Conselho funciona, com o texto integral das instruções) |
| Quem opera o Conselho | `PROMPT_CONSELHO_POLITICO_PACIFICADOR_DE_FAMILIAS_v1_2.md` e `modelos/` |
| Quem organiza o grupo | `PROPOSTA_ESTRUTURA_DO_GRUPO.md` |

## Arquivos

| Arquivo | Papel | Feito para participantes? |
|---|---|---|
| `PROMPT_CONSELHO_POLITICO_PACIFICADOR_DE_FAMILIAS_v1_2.md` | Prompt vigente do Conselho: princípios, escalas, instrumentos, cadeiras e convocação, modos, protocolo, mediação, Regras da Mesa, estrutura da Sentença, entregáveis visuais, templates de subagentes. **Vence em qualquer divergência.** | Sim, pelo Motor |
| `DECLARACAO_UNIVERSAL_DO_PACIFICADOR.html` | Apresentação e convite: motivação, Regras da Mesa (com a Regra de Ouro), os 12 artigos, mesa redonda interativa, travas de isonomia, teste do sinal invertido, compromisso de entrada e convites prontos para o WhatsApp | Sim |
| `MOTOR_DO_CONSELHO.html` | O motor às claras: engrenagem, convocação, 15 princípios, cadeiras e mandatos, auditoria de isonomia, escalas, instrumentos, conduta, falhas, comandos e texto integral do prompt | Sim |
| `sentencas/` | Sentenças publicadas (Executiva e Completa), quando houver | Sim |
| `PROPOSTA_ESTRUTURA_DO_GRUPO.md` | Como operar o grupo: WhatsApp, site, Claude, revisão humana, propagação, cuidados legais | Não (material de trabalho) |
| `REGISTRO_SENTENCAS_PACIFICADOR.template.md` | Template da jurisprudência do Conselho (append-only, mantido por humano) | Não (material de trabalho) |
| `modelos/` | Modelos visuais da Sentença Executiva e Completa, exemplo fictício (que serve de esquema) e scripts | Não (material de trabalho) |
| `historico/` | Versões anteriores do prompt e da Declaração | Não (material de trabalho) |
| `docs/HISTORICO_DE_DECISOES.md` | O que o fundador pediu e decidiu em cada rodada de construção, e por quê | Não (material de trabalho) |

## Composição do Conselho

10 cadeiras permanentes (Economista Empírico, Analista de Políticas Sociais, Jurista Constitucional e Federativo, Cientista Político Institucional, Investigador de Forças e Interesses, Geoestrategista, Guardião do Método, Filósofo Pluralista, O Cidadão, O Formulador), o **Auditor de Isonomia** (audita viés, não opina sobre mérito), o **Juiz** (convoca as cadeiras pertinentes a cada caso, redige a Sentença e conduz mediações) e cadeiras convidadas rotativas. O usuário pode convocar, sugerir ou dispensar cadeiras.

## Uso rápido

Cole o prompt como instrução de projeto no Claude (ou abra este repositório no Claude Code) e acione:

```text
pacificador: [objeto]                 sessão completa
pacificador rápido: [objeto]          até 5 cadeiras
pacificador checa: "[afirmação]"      checagem de fato
pacificador boletim: [governo]        conquistas, inversões, fracassos, heranças e marés
pacificador compara: A vs B           mesma régua, mesmo período
pacificador projeto: [PEC/PL nº]      análise de proposição legislativa
pacificador político: [nome]          promessas × votos × resultados × estado processual
pacificador forças: [objeto]          mapa de interesses e influências
pacificador media: [conversa]         mediação entre pessoas
pacificador + [cadeira]: [objeto]     convocar uma cadeira
```

## Site (GitHub Pages)

O site é publicado direto deste repositório, sem domínio próprio. Para ativar (uma vez só):

1. Levar o conteúdo para a branch `main`.
2. Em **Settings → Pages**, escolher **Deploy from a branch**, branch `main`, pasta `/ (root)`, e salvar.
3. Em alguns minutos o site fica no ar em https://gutofavero-hash.github.io/Pacificador-de-Familia/

| Endereço | Página |
|---|---|
| `/` | Abre a Declaração Universal |
| `/DECLARACAO_UNIVERSAL_DO_PACIFICADOR.html` | Declaração Universal e Regras da Mesa |
| `/MOTOR_DO_CONSELHO.html` | Motor do Conselho |
| `/sentencas/…` | Cada Sentença, com resumo executivo e versão completa |

Ao colar esses links no WhatsApp, aparece uma prévia com título, descrição e imagem (`assets/`).

## Scripts

```bash
# Gera a Sentença Executiva e a Completa a partir de um único JSON (saída em sentencas/)
python3 modelos/gerar_sentenca.py caminho/para/sentenca.json

# Atualiza o texto integral do prompt dentro do Motor — rodar sempre que o prompt mudar
python3 modelos/embutir_prompt.py
```
