#!/usr/bin/env bash
# Install Bibata cursor theme and Papirus icon theme
# These are AUR packages — requires paru/yay
set -euo pipefail

aur_helper=""
if command -v paru &>/dev/null; then
  aur_helper="paru"
elif command -v yay &>/dev/null; then
  aur_helper="yay"
else
  echo ":: No AUR helper found (paru/yay). Skipping cursor/icon theme install."
  exit 0
fi

echo ":: Installing cursor and icon themes via $aur_helper..."

$aur_helper -S --needed --noconfirm bibata-cursor-theme-bin papirus-icon-theme

echo ":: Themes installed. Set cursor in hyprland.conf if not already done."
