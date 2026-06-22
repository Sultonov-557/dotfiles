#!/usr/bin/env bash
# Create XDG user directories and ensure ~/work/, ~/Projects/ exist
set -euo pipefail

echo ":: Setting up XDG directories..."

# Ensure key directories exist
dirs=(
  "$HOME/work"
  "$HOME/Projects"
  "$HOME/Documents"
  "$HOME/Downloads"
  "$HOME/Music"
  "$HOME/Pictures"
  "$HOME/Videos"
  "$HOME/Desktop"
  "$HOME/Templates"
  "$HOME/Public"
)

for dir in "${dirs[@]}"; do
  mkdir -p "$dir"
done

# Run xdg-user-dirs-update if available
if command -v xdg-user-dirs-update &>/dev/null; then
  xdg-user-dirs-update
  echo ":: xdg-user-dirs-update completed"
else
  echo ":: xdg-user-dirs-update not found, created dirs manually"
fi

echo ":: XDG directories ready"
