#!/usr/bin/env bash
# Install Tmux Plugin Manager (TPM)
set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ -d "$TPM_DIR" ]; then
  echo ":: TPM already installed at $TPM_DIR, skipping"
  exit 0
fi

echo ":: Installing TPM..."
git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
echo ":: TPM installed. Press prefix + I inside tmux to install plugins."
