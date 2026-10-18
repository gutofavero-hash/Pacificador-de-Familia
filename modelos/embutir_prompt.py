#!/usr/bin/env python3
"""Embute o texto integral do prompt vigente em MOTOR_DO_CONSELHO.html.

Uso (rodar sempre que o prompt mudar — PROMPT §0):
    python3 modelos/embutir_prompt.py

Pega o PROMPT_CONSELHO_POLITICO_PACIFICADOR_DE_FAMILIAS_v*.md de versão mais alta,
remove o cabeçalho YAML (metadados internos) e grava o corpo entre
os marcadores PROMPT_INICIO e PROMPT_FIM da página do Motor.
"""
import re
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
MOTOR = RAIZ / "MOTOR_DO_CONSELHO.html"


def versao(p: Path) -> tuple:
    m = re.search(r"_v(\d+)_(\d+)\.md$", p.name)
    return (int(m.group(1)), int(m.group(2))) if m else (0, 0)


def main() -> None:
    prompts = sorted(RAIZ.glob("PROMPT_CONSELHO_POLITICO_PACIFICADOR_DE_FAMILIAS_v*.md"), key=versao)
    if not prompts:
        raise SystemExit("Prompt não encontrado.")
    prompt = prompts[-1]
    texto = prompt.read_text(encoding="utf-8")
    meta = {}
    if texto.startswith("---\n"):
        fim = texto.index("\n---\n", 4)
        for linha in texto[4:fim].splitlines():
            if re.match(r"^(versao|data):", linha):
                k, v = linha.split(":", 1)
                meta[k] = v.strip()
        texto = texto[fim + 5:]
    cabecalho = f"**Versão:** {meta.get('versao', '?')} · {meta.get('data', '')}\n\n"
    corpo = (cabecalho + texto.strip() + "\n").replace("</script", "<\\/script")
    html = MOTOR.read_text(encoding="utf-8")
    novo, n = re.subn(r"(<!--PROMPT_INICIO-->)(.*?)(<!--PROMPT_FIM-->)",
                      lambda m: m.group(1) + "\n" + corpo + m.group(3), html, count=1, flags=re.S)
    if n != 1:
        raise SystemExit("Marcadores PROMPT_INICIO/PROMPT_FIM não encontrados no Motor.")
    MOTOR.write_text(novo, encoding="utf-8")
    print(f"{prompt.name} → {MOTOR.name}")


if __name__ == "__main__":
    main()
