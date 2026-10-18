# Como convocar o Conselho

Guia rápido para quem leva um tema ao Conselho. Três comandos resolvem tudo.

## Onde

**Claude Code com este repositório aberto** (no navegador em claude.ai/code, no app do Claude ou no computador). É o caminho completo: valida, roda o Conselho, gera os dois documentos visuais e registra o precedente.

Sem acesso ao Claude Code, use o **Projeto no app do Claude** (`projeto-claude-ai/`) para validar perguntas, checar afirmações e mediar conversas. Ele não gera os arquivos do site.

## Os três comandos

| Comando | Para quê | Leva |
|---|---|---|
| `/pacificador-validar [tema como chegou]` | Confere as Regras da Mesa, reformula como "Quero entender…", diz se o tema cabe e qual modo usar. Devolve a Ficha da Pergunta com o comando pronto | 1 minuto |
| `/pacificador-rodada [modo]: [pergunta]` | Rodada completa: enquadramento, convocação, Dossiê de Fatos, pareceres em paralelo, revisão cruzada, auditoria de isonomia, Sentença, Executiva e Completa em `sentencas/`, registro | 10 a 30 minutos |
| `/pacificador-mediar [conversa colada]` | Media uma conversa entre pessoas, sem gravar nada no repositório | 2 minutos |

## O fluxo de uma rodada

```
tema chega ──► /pacificador-validar ──► Ficha da Pergunta + comando pronto
                                                │
                                                ▼
                         /pacificador-rodada [modo]: [pergunta]
                                                │
               confirma enquadramento e cadeiras (uma pergunta)
                                                │
                                                ▼
        Sentença (.md) + dados (.json) + Executiva e Completa (.html) em sentencas/
                                                │
                                                ▼
                 revisão humana de isonomia (2 ou 3 voluntários, 24 h)
                                                │
                                                ▼
             "publica a S-nnn" ──► vai para a main ──► site atualiza sozinho
                                                │
                                                ▼
                     texto pronto para o canal de Avisos e para a sala
```

## Cardápio: qual comando para cada tipo de debate

| Tipo de debate | Exemplo de tema | Comando |
|---|---|---|
| Uma política deu certo? | Programa de alfabetização do estado | `/pacificador-rodada completo: Quero entender se o programa X melhorou a alfabetização no estado Y desde 2019.` |
| Resposta em poucos minutos | O mesmo, mais enxuto | `/pacificador-rodada rápido: ...` |
| Frase que circulou no grupo | "O desemprego é o menor da história" | `/pacificador-rodada checa: "O desemprego é o menor da história."` |
| Balanço de um governo | Gestão estadual de 2019 a 2022 | `/pacificador-rodada boletim: governo do estado Y, 2019–2022` |
| Comparar governos, países ou políticas | Dois modelos de segurança pública | `/pacificador-rodada compara: modelo A vs modelo B, mesmo período` |
| Lei, PEC, PL, MP | Uma PEC em tramitação | `/pacificador-rodada projeto: PEC nº/ano` |
| Atuação de um político | Promessas e votos de um deputado | `/pacificador-rodada político: [nome]` |
| Quem ganha e quem perde | Interesses por trás de um projeto | `/pacificador-rodada forças: [tema]` |
| Conversa que esquentou | Mensagens coladas do grupo | `/pacificador-mediar [mensagens]` |

## Ajustes no mesmo comando

Acrescente ao fim do comando, quantos precisar:

| Ajuste | Efeito |
|---|---|
| `— sala: [nome]` | Liga a Sentença à sala de debate correspondente |
| `+ [cadeira]` | Convoca uma cadeira, obrigatoriamente |
| `— sugiro [cadeira]` | Sugere; o Juiz decide e justifica |
| `— sem [cadeira]` | Dispensa, salvo presença obrigatória |
| `— direto` | Pula a confirmação do enquadramento |

**Cadeiras:** Economista Empírico · Analista de Políticas Sociais · Jurista Constitucional e Federativo · Cientista Político Institucional · Investigador de Forças e Interesses · Geoestrategista · Guardião do Método · Filósofo Pluralista · O Cidadão · O Formulador. **Convidadas:** meio ambiente, segurança pública, saúde, educação, previdência, tributação, tecnologia, agro, infraestrutura e energia, comunicação, defesa, direitos humanos, liberdade religiosa, trabalho.

## Para publicar

Depois da revisão humana, diga no Claude Code: **"publica a Sentença S-nnn"**. O Claude faz o commit, abre o pull request para a `main` e, com a sua confirmação, faz o merge. O site atualiza em poucos minutos.
