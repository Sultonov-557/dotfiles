#!/usr/bin/env bash
# Set fish as the default shell
set -euo pipefail

FISH_PATH=$(command -v fish)
if [ -z "$FISH_PATH" ]; then
  echo ":: fish not found, install it first"
  exit 1
fi

if [ "$SHELL" = "$FISH_PATH" ]; then
  echo ":: fish is already the default shell"
  exit 0
fi

echo ":: Setting fish as default shell..."
echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
chsh -s "$FISH_PATH"
echo ":: Default shell set to fish (re-login to take effect)"
