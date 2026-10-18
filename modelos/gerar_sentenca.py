#!/usr/bin/env python3
"""Gera a Sentença Executiva e a Sentença Completa a partir de um único JSON.

Uso:
    python3 gerar_sentenca.py caminho/para/sentenca.json [pasta_de_saida]

A pasta de saída padrão é ../sentencas/. Os dois HTML recebem exatamente o mesmo
JSON (PROMPT §9-A, regra 1), então as duas versões nunca se contradizem.
Os nomes dos arquivos vêm de "documento_executivo" e "documento_completo".
"""
import html
import json
import re
import sys
from pathlib import Path

# Endereço do site no GitHub Pages; usado nas prévias de link (WhatsApp, redes sociais).
SITE = "https://gutofavero-hash.github.io/Pacificador-de-Familia/"

AQUI = Path(__file__).resolve().parent
MODELOS = {
    "documento_executivo": (AQUI / "SENTENCA_EXECUTIVA.template.html", "resumo executivo"),
    "documento_completo": (AQUI / "SENTENCA_COMPLETA.template.html", "versão completa"),
}
BLOCO = re.compile(r'(<script type="application/json" id="sentenca">)(.*?)(</script>)', re.S)


def previa(dados: dict, nome: str, tipo: str) -> str:
    titulo = f"Sentença {dados.get('id', '')} · {dados.get('objeto', '')}"
    resumo = (dados.get("resposta_curta") or "").strip()
    if len(resumo) > 220:
        resumo = resumo[:217].rsplit(" ", 1)[0] + "…"
    e = lambda v: html.escape(v, quote=True)
    return (f'<meta name="description" content="{e(resumo)}">\n'
            '<meta property="og:type" content="article">\n'
            '<meta property="og:site_name" content="O Pacificador de Famílias">\n'
            '<meta property="og:locale" content="pt_BR">\n'
            f'<meta property="og:title" content="{e(titulo)} ({tipo})">\n'
            f'<meta property="og:description" content="{e(resumo)}">\n'
            f'<meta property="og:url" content="{SITE}sentencas/{e(nome)}">\n'
            f'<meta property="og:image" content="{SITE}assets/og-sentenca.png">\n'
            '<meta property="og:image:width" content="1200">\n<meta property="og:image:height" content="630">\n'
            '<meta name="twitter:card" content="summary_large_image">')


def preencher(modelo: str, dados: dict, nome: str = "", tipo: str = "") -> str:
    # "</" escapado para que nenhum texto da Sentença feche a tag <script> antes da hora.
    carga = json.dumps(dados, ensure_ascii=False, indent=2).replace("</", "<\\/")
    novo, n = BLOCO.subn(lambda m: m.group(1) + carga + m.group(3), modelo, count=1)
    if n != 1:
        raise SystemExit("Bloco JSON da Sentença não encontrado no modelo.")
    if nome and "<!--OG_SENTENCA-->" in novo:
        novo = novo.replace("<!--OG_SENTENCA-->", previa(dados, nome, tipo), 1)
        novo = re.sub(r"<title>[^<]*</title>",
                      "<title>" + html.escape(f"Sentença {dados.get('id', '')} · {tipo}") + "</title>", novo, count=1)
    return novo


def main() -> None:
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    dados = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    saida = Path(sys.argv[2]) if len(sys.argv) > 2 else AQUI.parent / "sentencas"
    saida.mkdir(parents=True, exist_ok=True)
    for campo, (modelo, tipo) in MODELOS.items():
        nome = dados.get(campo)
        if not nome:
            raise SystemExit(f'Campo "{campo}" ausente no JSON.')
        destino = saida / nome
        destino.write_text(preencher(modelo.read_text(encoding="utf-8"), dados, nome, tipo), encoding="utf-8")
        print(destino)


if __name__ == "__main__":
    main()
