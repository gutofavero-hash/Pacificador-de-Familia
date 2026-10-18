#!/usr/bin/env python3
"""Gera a Sentença Executiva e a Sentença Completa a partir de um único JSON.

Uso:
    python3 gerar_sentenca.py caminho/para/sentenca.json [pasta_de_saida]

A pasta de saída padrão é ../sentencas/. Os dois HTML recebem exatamente o mesmo
JSON (PROMPT §9-A, regra 1), então as duas versões nunca se contradizem.
Os nomes dos arquivos vêm de "documento_executivo" e "documento_completo".
"""
import json
import re
import sys
from pathlib import Path

AQUI = Path(__file__).resolve().parent
MODELOS = {
    "documento_executivo": AQUI / "SENTENCA_EXECUTIVA.template.html",
    "documento_completo": AQUI / "SENTENCA_COMPLETA.template.html",
}
BLOCO = re.compile(r'(<script type="application/json" id="sentenca">)(.*?)(</script>)', re.S)


def preencher(modelo: str, dados: dict) -> str:
    # "</" escapado para que nenhum texto da Sentença feche a tag <script> antes da hora.
    carga = json.dumps(dados, ensure_ascii=False, indent=2).replace("</", "<\\/")
    novo, n = BLOCO.subn(lambda m: m.group(1) + carga + m.group(3), modelo, count=1)
    if n != 1:
        raise SystemExit("Bloco JSON da Sentença não encontrado no modelo.")
    return novo


def main() -> None:
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    dados = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    saida = Path(sys.argv[2]) if len(sys.argv) > 2 else AQUI.parent / "sentencas"
    saida.mkdir(parents=True, exist_ok=True)
    for campo, modelo in MODELOS.items():
        nome = dados.get(campo)
        if not nome:
            raise SystemExit(f'Campo "{campo}" ausente no JSON.')
        destino = saida / nome
        destino.write_text(preencher(modelo.read_text(encoding="utf-8"), dados), encoding="utf-8")
        print(destino)


if __name__ == "__main__":
    main()
