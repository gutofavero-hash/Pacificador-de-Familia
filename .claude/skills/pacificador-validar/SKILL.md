---
name: pacificador-validar
description: Valida um tema proposto para o Conselho do Pacificador de Famílias — confere as Regras da Mesa, reformula como pergunta de entendimento, verifica se o tema cabe no Conselho e devolve a Ficha da Pergunta com o comando pronto. Use quando alguém trouxer um tema, pergunta, afirmação ou briga para ser levada ao Conselho, ou quando pedirem "valida esse tema", "essa pergunta serve?", "pacificador valida". Não executa a rodada do Conselho.
---

# Validar um tema para o Conselho

Você recebe um tema do jeito que ele chegou (pode ser uma frase de briga de família, uma afirmação de WhatsApp, uma pergunta, um nome de lei). Devolve a **Ficha da Pergunta**. Não executa o Conselho.

## Antes de tudo

Leia, no repositório, o prompt vigente (`PROMPT_CONSELHO_POLITICO_PACIFICADOR_DE_FAMILIAS_v*.md` de versão mais alta, na raiz), em especial §2 (princípios), §6 (modos), §8-A (Regras da Mesa) e §5.0 (convocação). Se `REGISTRO_SENTENCAS_PACIFICADOR.md` existir, procure caso análogo já julgado.

## Passos

1. **Regras da Mesa.** O texto começa por acusação ao outro lado, usa rótulo desqualificador, ou responde a um erro com o erro do outro lado ("mas o outro também")? Se sim, aponte com gentileza qual regra foi tocada, sem julgar a pessoa, e reformule. Nunca repita o rótulo, exceto entre aspas para identificá-lo.
2. **Reformulação.** Escreva a pergunta no formato "Quero entender [objeto]. [pergunta]." Ela precisa passar no teste do enquadramento: apoiadores e opositores aceitariam a pergunta como justa?
3. **O tema cabe no Conselho?** Cabe se for sobre política pública, lei, proposição, decisão, governo, atos de agente público, resultado controverso ou afirmação verificável. **Não cabe** (explique por quê e proponha alternativa): pedido de voto ou de campanha, ataque ou defesa encomendada de pessoa, vida privada, pessoa comum identificável, pergunta de pura fé sem dimensão pública.
4. **A pergunta é respondível?** Tem objeto, lugar e período? Se for composta, divida em perguntas separadas e indique qual vai primeiro. Se faltar algo essencial, faça **uma** pergunta de esclarecimento ao usuário.
5. **Classificação.** Modo recomendado (§6), esferas e Poderes envolvidos, período sugerido, 3 a 5 indicadores candidatos (a escolher antes de ver resultados), cadeiras prováveis e por quê, risco de falta de dado.
6. **Precedente.** Cite Sentença anterior análoga, se houver.

## Saída (formato fixo)

```
FICHA DA PERGUNTA

Como chegou: "[texto original]"
Regras da Mesa: [OK | regra tocada e por quê, em uma linha gentil]
Pergunta de entendimento: "Quero entender ... ?"
Cabe no Conselho: [Sim | Não — motivo e alternativa]
Modo recomendado: [completo | rápido | checa | boletim | compara | projeto | político | forças | media]
Esferas e Poderes: [...]
Período sugerido: [...]
Indicadores candidatos: [...]
Cadeiras prováveis: [lista com uma linha de motivo cada; obrigatórias: Guardião do Método, Cidadão, Auditor]
Risco de dado: [baixo | médio | alto — por quê]
Precedente: [S-xxx ou nenhum]

Comando pronto:
/pacificador-rodada [modo]: [pergunta de entendimento]
```

Português do Brasil, direto. Não invente números: esta etapa não usa dados.
