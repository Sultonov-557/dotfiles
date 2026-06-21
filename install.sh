#!/usr/bin/env bash
# =============================================================================
# install.sh — Bootstrap a new machine
# The only script you run manually. Everything else is chezmoi run_once_*.
#
# Usage:
#   bash install.sh                          # from cloned repo
#   bash <(curl -fsSL https://raw.githubusercontent.com/<user>/<repo>/main/install.sh)
# =============================================================================
set -uo pipefail

# ── Install chezmoi ───────────────────────────────────────────────────────────
if ! command -v chezmoi &>/dev/null; then
  echo ":: Installing chezmoi..."
  if command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm chezmoi
  elif command -v brew &>/dev/null; then
    brew install chezmoi
  else
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

# ── Determine source directory ────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)"

if [ -d "$SCRIPT_DIR/dot_config" ] && [ -d "$SCRIPT_DIR/.git" ]; then
  echo ":: Applying dotfiles from $SCRIPT_DIR..."
  chezmoi init --apply "$SCRIPT_DIR" || true
elif [ -d "$HOME/.local/share/chezmoi/dot_config" ]; then
  echo ":: Applying dotfiles..."
  chezmoi apply || true
else
  REPO_URL="https://github.com/Sultonov-557/dotfiles.git"
  echo ":: Cloning dotfiles from $REPO_URL..."
  chezmoi init --apply "$REPO_URL" || true
fi

echo ""
echo ":: Done! If any run_once scripts failed (e.g. sudo), re-run: chezmoi apply"
