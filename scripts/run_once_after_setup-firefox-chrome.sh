#!/usr/bin/env bash
# =============================================================================
# run_once_after_setup-firefox-chrome.sh
# Deploy Zen/Firefox userChrome.css into the browser profile directory.
# =============================================================================
set -euo pipefail

CHROME_SRC="$HOME/.config/zen/browser/chrome"

deploy_chrome() {
  local profile_dir="$1"
  local name="$2"
  if [ -z "$profile_dir" ] || [ ! -d "$profile_dir" ]; then
    return 0
  fi
  local chrome_dst="$profile_dir/chrome"
  mkdir -p "$chrome_dst"
  if [ -f "$CHROME_SRC/userChrome.css" ]; then
    cp "$CHROME_SRC/userChrome.css" "$chrome_dst/"
    echo ":: $name userChrome.css installed to $chrome_dst"
  else
    echo ":: $name chrome source not found at $CHROME_SRC/userChrome.css"
  fi
}

# Try Zen browser — profile is in ~/.config/zen/ (not ~/.zen/)
zen_profile=""
if [ -d "$HOME/.config/zen" ]; then
  zen_profile=$(find "$HOME/.config/zen" -maxdepth 1 -type d -name '*default*' 2>/dev/null | head -1)
  deploy_chrome "$zen_profile" "Zen"
fi

# Try Firefox
ff_profile=""
if [ -d "$HOME/.mozilla/firefox" ]; then
  ff_profile=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name '*.default*' 2>/dev/null | head -1)
  deploy_chrome "$ff_profile" "Firefox"
fi

if [ -z "$zen_profile" ] && [ -z "$ff_profile" ]; then
  echo ":: No Zen or Firefox profile found. Install the browser first, then re-run."
  echo "::   chezmoi apply"
fi
