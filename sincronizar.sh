#!/usr/bin/env bash
# Copia as skills locais para o repo, procura dados pessoais e faz push.
# Uso: bash sincronizar.sh
set -euo pipefail
cd "$(dirname "$0")"
DEST=plugins/skills-ptbr/skills
SRC="$HOME/.claude/skills"
copiar() { rm -rf "$DEST/$1"; cp -r "$2" "$DEST/$1"; }
copiar revisar-seguranca "$SRC/revisar-seguranca"
copiar auditoria-111 "$SRC/auditoria-111"
CTX=$(find "$SRC/synced" -maxdepth 2 -type d -name arquivos-de-contexto | head -1)
[ -n "$CTX" ] && copiar arquivos-de-contexto "$CTX"
find "$DEST" -name __pycache__ -prune -exec rm -rf {} +

# Bloqueia o push se achar algo pessoal
PADRAO='uande|uanderson|batista|gmail|hotmail|[A-Za-z]:[/\]Users|(sk|pk|rk)_(live|test)_[A-Za-z0-9]{8}|sk-[A-Za-z0-9]{16}|ghp_[A-Za-z0-9]{20}|AKIA[A-Z0-9]{12}|eyJ[A-Za-z0-9_-]{20}|9[0-9]{4}-?[0-9]{4}|[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}'
if grep -rniIE "$PADRAO" "$DEST"; then
  echo "PARADO: possivel dado pessoal acima. Nada foi enviado."; exit 1
fi

git add -A
git diff --cached --quiet && { echo "Sem mudancas."; exit 0; }
git commit -qm "Atualiza skills ($(date +%F))"
git push -q && echo "Enviado."
