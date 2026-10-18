# CLAUDE.md — O Pacificador de Famílias

Instruções para qualquer sessão de trabalho neste repositório.

## 1 · O que é

Repositório próprio e independente do **Pacificador de Famílias**, Conselho Político Permanente criado por Augusto Silveira Fávero em 18/10/2026. Tudo o que diz respeito ao projeto (prompt, documentos, versões, decisões, Sentenças) é construído e consolidado **aqui**. O projeto não depende de nenhum outro repositório.

## 2 · Hierarquia de documentos

1. `PROMPT_CONSELHO_POLITICO_PACIFICADOR_DE_FAMILIAS_v*.md` (versão mais alta, na raiz) — **vence sempre**.
2. `MOTOR_DO_CONSELHO.html` e `DECLARACAO_UNIVERSAL_DO_PACIFICADOR.html` — espelhos para participantes. Divergiu do prompt, corrige-se o espelho na mesma sessão.
3. `PROPOSTA_ESTRUTURA_DO_GRUPO.md` — planejamento operacional.

## 3 · Regras de manutenção

- **Toda mudança no prompt** propaga na mesma sessão: rodar `python3 modelos/embutir_prompt.py` (texto integral no Motor), revisar as seções resumidas do Motor e da Declaração e registrar no changelog do prompt.
- **Nova versão do prompt:** a versão vigente fica na raiz; a anterior vai para `historico/prompts/` sem alterações. Atualizar referências ao nome do arquivo (`README.md`, Motor, registro).
- **Toda decisão do fundador** entra em `docs/HISTORICO_DE_DECISOES.md`, com data, o que foi pedido, o que foi feito e o que ficou pendente.
- **Sentenças:** preencher um JSON no esquema de `modelos/exemplo_sentenca.json` e gerar os dois HTML com `python3 modelos/gerar_sentenca.py`. Nunca editar o layout à mão; nunca deixar dado do exemplo fictício numa Sentença real (`"exemplo": false`).
- **Checagem pós-alteração:** blocos de código balanceados, contagem de linhas antes e depois (queda inesperada indica perda de conteúdo), seções vizinhas intactas, scripts das páginas HTML sem erro de sintaxe.
- Português do Brasil, linguagem direta.

## 4 · Circulação

- **Circulam entre convidados e participantes** (decisão do fundador, 18/10/2026): a Declaração Universal, as Regras da Mesa, o Motor do Conselho (com o texto integral do prompt, sem o cabeçalho interno) e as Sentenças.
- **Uso interno até decisão do fundador:** proposta de estrutura, registro de sentenças, modelos, histórico e documentação em `docs/`.
- Publicação aberta na internet (site, repositório público) depende de decisão expressa do fundador.

## 5 · Princípios que nenhuma alteração pode violar

Os do próprio Conselho (prompt §2), em especial: régua única, teste do sinal invertido, número nunca inventado, nenhum governo ou pessoa poupado, o Conselho não indica voto, e as Regras da Mesa (prompt §8-A) valem também para o Conselho.
