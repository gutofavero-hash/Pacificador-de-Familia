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
- **Convocar o Conselho:** use as skills em `.claude/skills/` (`/pacificador-validar`, `/pacificador-rodada`, `/pacificador-mediar`); o guia é `CONVOCAR_O_CONSELHO.md`. Mudança de fluxo ou de comando atualiza as skills, o guia e `projeto-claude-ai/` juntos.
- **Sentenças:** preencher um JSON no esquema de `modelos/exemplo_sentenca.json` e gerar os dois HTML com `python3 modelos/gerar_sentenca.py`. Nunca editar o layout à mão; nunca deixar dado do exemplo fictício numa Sentença real (`"exemplo": false`).
- **Checagem pós-alteração:** blocos de código balanceados, contagem de linhas antes e depois (queda inesperada indica perda de conteúdo), seções vizinhas intactas, scripts das páginas HTML sem erro de sintaxe.
- Português do Brasil, linguagem direta.

## 4 · Publicação

- **O repositório é público** (decisão do fundador, 18/10/2026). Todo arquivo aqui pode ser lido por qualquer pessoa: nunca grave dado pessoal de participantes, conversas privadas, credenciais ou qualquer coisa que não possa ser pública.
- **Site:** GitHub Pages, sem domínio próprio, em `https://gutofavero-hash.github.io/Pacificador-de-Familia/`, publicado a partir da raiz da branch `main`. `index.html` leva à Declaração.
- **Material feito para participantes:** a Declaração Universal, as Regras da Mesa, o Motor do Conselho (com o texto integral do prompt) e as Sentenças em `sentencas/`. É o que se divulga e se envia nos grupos.
- **Material de trabalho** (também público, mas não divulgado ativamente): proposta de estrutura, registro de sentenças, modelos, histórico e `docs/`.
- **Prévias de link:** as páginas para participantes têm metadados Open Graph apontando para as imagens em `assets/`. O endereço do site está fixado nessas páginas e em `modelos/gerar_sentenca.py` (`SITE`); se o endereço mudar, atualizar os dois.

## 5 · Princípios que nenhuma alteração pode violar

Os do próprio Conselho (prompt §2), em especial: régua única, teste do sinal invertido, número nunca inventado, nenhum governo ou pessoa poupado, o Conselho não indica voto, e as Regras da Mesa (prompt §8-A) valem também para o Conselho.
