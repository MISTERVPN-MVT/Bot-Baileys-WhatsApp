# Author: @MISTERVPN
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
RESET=$'\e[0m'
BOLD=$'\e[1m'
CYAN=$'\e[36m'
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
BLUE=$'\e[34m'

spinner() {
  local msg="$1"; local pid="$2"
  local frames=('⠋' '⠙' '⠚' '⠒' '⠂' '⠂' '⠒' '⠑' '⠋')
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r${CYAN}%s ${BLUE}%s${RESET}" "$msg" "${frames[$i]}"
    i=$(((i + 1) % ${#frames[@]}))
    sleep 0.1
  done
  wait "$pid" || true
  printf "\r${GREEN}%s OK${RESET}\n" "$msg"
}

header() {
  echo -e "${BLUE}+----------------------------------------+${RESET}"
  echo -e "${BLUE}|${RESET}${BOLD}${CYAN}         WPP Bot Installer        ${RESET}${BLUE}|${RESET}"
  echo -e "${BLUE}+----------------------------------------+${RESET}"
}

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

header
echo

(
  download "$REPO_RAW_BASE/wpp" "$tmp"
) &
dlpid=$!
spinner "Baixando WPP (CLI)" "$dlpid"

(
  install -m 0755 "$tmp" "$BIN_PATH"
  sleep 2
) &
instpid=$!
spinner "Instalando WPP" "$instpid"

echo -e "${GREEN}Instalado em: ${BIN_PATH}${RESET}"
echo -e "${CYAN}Agora execute: ${BOLD}wpp${RESET}"
