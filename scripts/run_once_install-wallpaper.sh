#!/usr/bin/env bash
# =============================================================================
# run_once_install-wallpaper.sh
# Wallpapers are bundled in dotfiles/dot_pictures/Wallpapers/
# and deployed automatically by chezmoi (files apply before run_once scripts).
# =============================================================================
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
PRIMARY_WALL="$WALLPAPER_DIR/gruvbox.png"

if [ -f "$PRIMARY_WALL" ]; then
  echo ":: Wallpapers deployed to $WALLPAPER_DIR"
  echo ":: Available: gruvbox.png, catppuccin.png, everforest.png, nord.png"
else
  echo ":: Wallpapers not deployed yet — run 'chezmoi apply' again or copy manually"
  echo ":: Expected location: $WALLPAPER_DIR/"
fi

exit 0
