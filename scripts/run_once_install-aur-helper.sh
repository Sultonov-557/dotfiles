#!/usr/bin/env bash
# Install paru AUR helper if not already present
set -euo pipefail

if command -v paru &>/dev/null; then
  echo ":: paru already installed, skipping"
  exit 0
fi

echo ":: Installing paru..."

# paru deps
sudo pacman -S --needed --noconfirm base-devel git

tmpdir=$(mktemp -d)
cd "$tmpdir"

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

cd /
rm -rf "$tmpdir"

echo ":: paru installed successfully"
