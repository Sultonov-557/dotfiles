#!/usr/bin/env bash
# Install Tmux Plugin Manager (TPM)
# NOTE: tmux has been replaced by herdr. This script is kept for reference
# but no longer runs automatically during setup.
set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
  echo ":: TPM already installed at $TPM_DIR, skipping"
  exit 0
fi

echo ":: tmux is no longer the primary multiplexer (herdr replaces it)."
echo ":: Skipping TPM install. To install anyway, run:"
echo "::   git clone https://github.com/tmux-plugins/tpm \"$TPM_DIR\""
exit 0
