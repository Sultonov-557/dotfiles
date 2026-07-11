#!/usr/bin/env bash
# =============================================================================
# run_once_after_setup-system-config.sh
# Deploy system-level configs to /etc/ using sudo.
# Config source files in ~/.local/share/chezmoi/dot_etc/
# =============================================================================
set -euo pipefail

CHEZMOI_SOURCE=$(chezmoi source-path 2>/dev/null || echo "$HOME/.local/share/chezmoi")

deploy_file() {
  local src="$1"
  local dst="$2"
  if [ ! -f "$src" ]; then
    echo ":: Skipping $dst — source not found at $src"
    return 0
  fi
  if [ -f "$dst" ]; then
    if diff -q "$src" "$dst" &>/dev/null; then
      echo ":: $dst already up to date"
      return 0
    fi
  fi
  sudo install -m 644 -o root -g root "$src" "$dst"
  echo ":: Deployed $dst"
}

PARU_SRC="$CHEZMOI_SOURCE/dot_etc/paru.conf"
REFLECTOR_SRC="$CHEZMOI_SOURCE/dot_etc/xdg/reflector/reflector.conf"
SYSCTL_SRC="$CHEZMOI_SOURCE/dot_etc/sysctl.d/90-sultanov.conf"

deploy_file "$PARU_SRC" "/etc/paru.conf"
deploy_file "$REFLECTOR_SRC" "/etc/xdg/reflector/reflector.conf"
deploy_file "$SYSCTL_SRC" "/etc/sysctl.d/90-sultanov.conf"

echo ":: System configs deployed. Reload sysctl: sysctl --system"
