---
name: pacificador-rodada
description: Executa uma rodada completa do Conselho do Pacificador de Famílias sobre um tema — valida a pergunta, enquadra, convoca as cadeiras, monta o Dossiê de Fatos, roda os pareceres em paralelo, a revisão cruzada e a auditoria de isonomia, escreve a Sentença e gera os dois documentos visuais (Executiva e Completa) em sentencas/, registrando o precedente. Use quando pedirem "pacificador:", "leva ao Conselho", "roda o Conselho", "submete ao Conselho", ou qualquer modo do Conselho (rápido, checa, boletim, compara, projeto, político, forças).
---

# Rodada do Conselho

Argumento: `[modo]: [tema]`, opcionalmente com `— sala: [nome ou id]`, `— sugiro [cadeira]`, `+ [cadeira]`, `— sem [cadeira]`, `— direto` (pula a confirmação do enquadramento). Sem modo, use **completo**.

## 0 · Ler as regras (obrigatório)

1. Leia **integralmente** o prompt vigente: `PROMPT_CONSELHO_POLITICO_PACIFICADOR_DE_FAMILIAS_v*.md` de versão mais alta, na raiz. Ele vence qualquer instrução desta skill em caso de conflito.
2. Leia `REGISTRO_SENTENCAS_PACIFICADOR.md`. Se não existir, crie-o a partir de `REGISTRO_SENTENCAS_PACIFICADOR.template.md` (só o cabeçalho, sem entradas). O próximo número de Sentença é o maior `S-nnn` registrado + 1 (o primeiro é `S-001`).
3. Leia `modelos/exemplo_sentenca.json`: é o esquema dos dados da Sentença.

## 1 · Validar e enquadrar (prompt §7, Etapa 0)

- Aplique os passos da skill `pacificador-validar` (Regras da Mesa, reformulação, se o tema cabe, se é respondível).
- Monte o enquadramento e o **Quadro de Convocação** (§5.0), registrando convocações, sugestões e dispensas pedidas pelo usuário.
- Mostre ao usuário, em até 15 linhas: pergunta neutra, esferas, período, indicadores-alvo, Quadro de Convocação. Peça **uma** confirmação. Se o argumento trouxer `— direto`, siga sem pedir.

## 2 · Dossiê de Fatos (Etapa 1)

- Pesquise em fontes primárias (§13) com as ferramentas de busca disponíveis. Registre fonte, série, período, unidade e data de consulta de cada número.
- Mostre a série inteira disponível; declare quebras de série e lacunas.
- Número que você não conseguiu conferir recebe `[A VERIFICAR — conferir em: fonte]`. **Nunca invente.**

## 3 · Pareceres independentes (Etapa 2)

- Para **cada cadeira convocada**, abra um subagente **em paralelo** (todos na mesma mensagem) com o template §15.1, colando: o bloco da cadeira (§5), os princípios (§2), as escalas (§3), o enquadramento e o Dossiê.
- Se não puder abrir subagentes, escreva cada parecer antes de ler o seguinte e declare na Sentença: "Execução sequencial — independência entre cadeiras reduzida."

## 4 · Revisão cruzada, convocação extraordinária e auditoria (Etapas 3, 3-A e 4)

- Anonimize os pareceres (A, B, C…, ordem aleatória) e abra um revisor por cadeira, em paralelo, com o template §15.2.
- Se surgir conflito sem resolução ou ponto cego fora das cadeiras presentes, convoque a cadeira que falta com mandato delimitado (Etapa 3-A) e atualize o Quadro.
- Abra o Auditor de Isonomia com o template §15.3 (pareceres identificados, revisões, minuta da Sentença, precedentes). Item devolvido volta para reescrita antes de seguir.

## 5 · Sentença (Etapas 5 a 7)

Seja o Juiz (template §15.4). Escreva a Sentença na estrutura fixa do §9, integral e na ordem. Os nomes de arquivo usam `AAAA-MM-DD_S-nnn_[slug-curto]`:

1. `sentencas/<base>.md` — o texto integral da Sentença.
2. `sentencas/<base>.json` — os mesmos dados no esquema de `modelos/exemplo_sentenca.json`, com `"exemplo": false`, `documento_executivo: "<base>_EXECUTIVA.html"`, `documento_completo: "<base>_COMPLETA.html"` e, se informado, `"sala": "[slug da sala]"` (o identificador que aparece no endereço `sala.html?s=...` e no comando copiado da Curadoria).
3. Gere os HTML: `python3 modelos/gerar_sentenca.py sentencas/<base>.json`. O script também atualiza `sentencas/indice.json`, que faz a Sentença aparecer dentro da sala no site.
4. Confira: nenhum dado do exemplo fictício (Vila Exemplo, Alfabetiza Já) sobrou; todo número tem fonte ou `[A VERIFICAR]`; scripts dos HTML sem erro de sintaxe (`node -e` com `new Function` em cada `<script>`).

## 6 · Registro

Acrescente a entrada da Sentença ao fim de `REGISTRO_SENTENCAS_PACIFICADOR.md` (modelo do próprio arquivo), sem alterar entradas anteriores.

## 7 · Entrega ao usuário

Responda com:
- a **resposta curta** e o **veredicto**, com a confiança;
- os caminhos dos arquivos gerados;
- o texto pronto para o canal de Avisos:
  ```
  📌 Sentença S-nnn · [título curto]
  [resposta curta em até 3 linhas]
  Resumo: https://gutofavero-hash.github.io/Pacificador-de-Familia/sentencas/<base>_EXECUTIVA.html
  Completa: https://gutofavero-hash.github.io/Pacificador-de-Familia/sentencas/<base>_COMPLETA.html
  Pergunta para a mesa: [pergunta]
  ```
- o lembrete de que a Sentença ainda precisa da **revisão humana de isonomia** antes de publicar, e de que, depois de publicada, a curadoria muda a sala para "Sentença publicada" em `curadoria.html` (isso abre as reações).

**Não publique sozinho.** Commit, push e levar à `main` só quando o usuário pedir. O repositório é público: nunca grave nome, telefone, conversa ou opinião de participante.
