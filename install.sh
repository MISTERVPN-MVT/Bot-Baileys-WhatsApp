#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# ==============================================================
# Installer: WPP Bot Manager
# Usage:
#   bash <(curl -fsSL <RAW_URL>/install.sh)
# ==============================================================

REPO_RAW_BASE_DEFAULT="https://raw.githubusercontent.com/MISTERVPN-MVT/Bot-Baileys-WhatsApp/main"
REPO_RAW_BASE="${REPO_RAW_BASE:-$REPO_RAW_BASE_DEFAULT}"

BIN_PATH="/usr/local/bin/wpp"

need_root() {
  if [[ "$(id -u)" -ne 0 ]]; then
    echo "Execute como root (ou com sudo)."
    exit 1
  fi
}

download() {
  local url="$1" out="$2"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url" -o "$out"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$out" "$url"
  else
    echo "curl/wget não encontrado. Instale e tente novamente."
    exit 1
  fi
}

need_root

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

echo "Baixando WPP (CLI) ..."
download "$REPO_RAW_BASE/wpp" "$tmp"

install -m 0755 "$tmp" "$BIN_PATH"

echo "Instalado em: $BIN_PATH"
echo "Agora execute: wpp"
