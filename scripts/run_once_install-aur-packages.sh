#!/usr/bin/env bash
# Install AUR packages from packages.txt (AUR section)
set -euo pipefail

if ! command -v paru &>/dev/null; then
  echo ":: paru not found, install it first (run_once_install-aur-helper.sh)"
  exit 0
fi

PACKAGE_FILE="{{ .chezmoi.sourceDir }}/packages.txt"

if [ ! -f "$PACKAGE_FILE" ]; then
  echo ":: packages.txt not found at $PACKAGE_FILE, skipping"
  exit 0
fi

echo ":: Installing AUR packages..."

AUR_PKGS=()
in_aur_section=false

while IFS= read -r line || [ -n "$line" ]; do
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"

  [[ -z "$line" ]] || [[ "$line" == \#* ]] && continue
  [[ "$line" == *──* ]] && continue

  # Detect AUR section
  if [[ "$line" == *"AUR"* ]]; then
    in_aur_section=true
    continue
  fi

  # If we hit a new section after AUR, stop
  if $in_aur_section && [[ "$line" == "# ──"* ]]; then
    break
  fi

  if $in_aur_section; then
    line="${line%%#*}"
    line="${line%"${line##*[![:space:]]}"}"
    [[ -z "$line" ]] && continue
    AUR_PKGS+=("$line")
  fi
done < "$PACKAGE_FILE"

if [ ${#AUR_PKGS[@]} -eq 0 ]; then
  echo ":: No AUR packages to install"
  exit 0
fi

echo "  Packages: ${AUR_PKGS[*]}"
paru -S --needed --noconfirm "${AUR_PKGS[@]}"
echo ":: AUR packages installed"
