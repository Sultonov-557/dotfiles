#!/usr/bin/env bash
# =============================================================================
# run_once_install-wallpaper.sh
# Wallpapers are deployed directly by chezmoi from Pictures/Wallpapers/
# (tracked in the dotfiles repo, not a submodule).
# =============================================================================
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

if [ -d "$WALLPAPER_DIR" ]; then
  COUNT=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) 2>/dev/null | wc -l)
  echo ":: Wallpapers deployed ($COUNT wallpapers)"
  echo ":: Location: $WALLPAPER_DIR/"
else
  echo ":: Wallpaper directory not found at $WALLPAPER_DIR — check chezmoi apply ran cleanly"
fi

exit 0
