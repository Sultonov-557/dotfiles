#!/usr/bin/env bash
# =============================================================================
# run_once_install-wallpaper.sh
# Download or create a default Gruvbox wallpaper.
# =============================================================================
set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
DEFAULT_WALL="$WALLPAPER_DIR/gruvbox_mountains.png"
GITHUB_WALL="https://raw.githubusercontent.com/Sultonov-557/dotfiles/main/misc/wallpapers/gruvbox_mountains.png"

if [ -f "$DEFAULT_WALL" ]; then
  echo ":: Wallpaper already exists at $DEFAULT_WALL, skipping"
  exit 0
fi

mkdir -p "$WALLPAPER_DIR"

echo ":: Downloading default Gruvbox wallpaper..."
if command -v curl &>/dev/null; then
  if curl -fsSL -o "$DEFAULT_WALL" "$GITHUB_WALL"; then
    echo ":: Wallpaper downloaded to $DEFAULT_WALL"
    exit 0
  fi
fi

if command -v wget &>/dev/null; then
  if wget -q -O "$DEFAULT_WALL" "$GITHUB_WALL"; then
    echo ":: Wallpaper downloaded to $DEFAULT_WALL"
    exit 0
  fi
fi

# If all downloads failed, write a note as placeholder
echo ":: Download failed — creating placeholder note"
cat > "$DEFAULT_WALL" << 'PLACEHOLDER'
This is a placeholder for the Gruvbox Mountains wallpaper.
Download a real wallpaper from: https://www.gruvbox-wallpapers.com
or run: curl -fsSL https://raw.githubusercontent.com/Sultonov-557/dotfiles/main/misc/wallpapers/gruvbox_mountains.png -o ~/Pictures/Wallpapers/gruvbox_mountains.png
PLACEHOLDER

echo ":: Placeholder created at $DEFAULT_WALL (replace with actual wallpaper)"
exit 0
