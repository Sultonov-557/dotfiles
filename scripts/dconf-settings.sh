#!/usr/bin/env bash
# dconf settings — export/import for chezmoi
# Usage: ./scripts/dconf-settings.sh [save|load]
#
# Save:   dconf dump /org/gnome/desktop/interface/ > .config/dconf/settings.ini
# Load:   dconf load /org/gnome/desktop/interface/ < .config/dconf/settings.ini
#
# This tracks only curated schemas — not the binary ~/.config/dconf/user blob.
# Add schemas here as needed.

set -euo pipefail

SCHEMAS=(
  /org/gnome/desktop/interface/
  /org/gnome/desktop/peripherals/keyboard/
  /org/gnome/desktop/input-sources/
  /org/gnome/desktop/wm/preferences/
  /org/gnome/settings-daemon/plugins/media-keys/
  /io/missioncenter/MissionCenter/
)

case "${1:-help}" in
  save)
    for schema in "${SCHEMAS[@]}"; do
      dir="$(dirname "$schema")"
      name="$(basename "$schema")"
      mkdir -p "/home/sultonov/.local/share/chezmoi/dot_config/dconf"
      dconf dump "$schema" > "/home/sultonov/.local/share/chezmoi/dot_config/dconf/${dir//\//_}_${name}.ini" 2>/dev/null || true
    done
    echo "dconf settings saved to chezmoi source"
    ;;
  load)
    for f in /home/sultonov/.local/share/chezmoi/dot_config/dconf/*.ini; do
      [ -f "$f" ] || continue
      # Parse schema path from filename
      schema="/${f##*/}"; schema="${schema%_*.ini}"; schema="${schema//_//}"
      dconf load "$schema" < "$f" 2>/dev/null || true
    done
    echo "dconf settings loaded from chezmoi source"
    ;;
  *)
    echo "Usage: $0 [save|load]"
    echo "  save — export settings to chezmoi source"
    echo "  load — import settings from chezmoi source"
    ;;
esac
