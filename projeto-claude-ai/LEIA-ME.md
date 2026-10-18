# Projeto "Pacificador" no app do Claude

Para usar o Conselho direto no app do Claude (celular ou navegador), sem abrir o repositório. Serve para **validar perguntas, checar afirmações, mediar conversas e rodadas rápidas**. Para gerar os documentos visuais e publicar no site, use o Claude Code (ver `CONVOCAR_O_CONSELHO.md`).

## Como criar (cerca de 3 minutos, uma vez só)

1. No app do Claude, abra **Projetos → Criar projeto**. Nome: `Pacificador de Famílias`.
2. Em **Instruções do projeto**, cole o conteúdo de `INSTRUCOES_DO_PROJETO.md` (está nesta pasta).
3. Em **Conhecimento do projeto**, envie estes arquivos do repositório:
   - `PROMPT_CONSELHO_POLITICO_PACIFICADOR_DE_FAMILIAS_v1_2.md` (o prompt vigente; troque quando houver versão nova)
   - `modelos/exemplo_sentenca.json` (esquema dos dados da Sentença)
   - `REGISTRO_SENTENCAS_PACIFICADOR.md`, quando existir (precedentes)
4. Ative a **busca na web** nas conversas do projeto, para o Dossiê de Fatos usar dados atuais.

## Como usar

Em cada conversa nova do projeto, digite um dos comandos:

```
valida: [tema como chegou]
pacificador rápido: [pergunta]
pacificador checa: "[afirmação]"
pacificador media: [mensagens coladas]
pacificador: [pergunta]          (rodada completa, sem os arquivos visuais)
```

Para levar uma rodada feita aqui ao site, peça no fim: **"me dá o JSON da Sentença"**, e use esse JSON no Claude Code com `python3 modelos/gerar_sentenca.py`.
