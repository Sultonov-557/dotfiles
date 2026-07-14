#!/usr/bin/env bash
# =============================================================================
# run_once_install-wallpaper.sh
# Wallpapers are deployed via git submodule (orangci/walls-catppuccin-mocha)
# at Pictures/Wallpapers/catppuccin-mocha/
# =============================================================================
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WALLS_SUBMODULE="$WALLPAPER_DIR/catppuccin-mocha"

if [ -d "$WALLS_SUBMODULE" ]; then
  COUNT=$(find "$WALLS_SUBMODULE" -type f \( -name "*.jpg" -o -name "*.png" \) 2>/dev/null | wc -l)
  echo ":: Catppuccin Mocha wallpapers deployed ($COUNT wallpapers)"
  echo ":: Location: $WALLS_SUBMODULE/"
else
  echo ":: Wallpaper submodule not initialized — run:"
  echo "    cd ~/.local/share/chezmoi && git submodule update --init --depth 1"
  echo "  then 'chezmoi apply' to deploy"
fi

exit 0
