[1mdiff --git a/install.sh b/install.sh
new file mode 100644
index 0000000000000000000000000000000000000000..f1a514255cb7be899b729ba1fd729c6bbb8913dc
--- /dev/null
+++ b/install.sh[m
[36m@@ -0,0 +1,50 @@[m
[32m+#!/usr/bin/env bash[m
[32m+# =============================================================================[m
[32m+# install.sh — Bootstrap a new machine[m
[32m+# The only script you run manually. Everything else is chezmoi run_once_*.[m
[32m+#[m
[32m+# Usage:[m
[32m+#   bash install.sh                          # from cloned repo[m
[32m+#   bash <(curl -fsSL https://raw.githubusercontent.com/<user>/<repo>/main/install.sh)[m
[32m+# =============================================================================[m
[32m+set -uo pipefail[m
[32m+[m
[32m+# ── Install chezmoi ───────────────────────────────────────────────────────────[m
[32m+if ! command -v chezmoi &>/dev/null; then[m
[32m+  echo ":: Installing chezmoi..."[m
[32m+  if command -v pacman &>/dev/null; then[m
[32m+    sudo pacman -S --noconfirm chezmoi[m
[32m+  elif command -v brew &>/dev/null; then[m
[32m+    brew install chezmoi[m
[32m+  else[m
[32m+    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin[m
[32m+    export PATH="$HOME/.local/bin:$PATH"[m
[32m+  fi[m
[32m+fi[m
[32m+[m
[32m+# ── Determine source directory ────────────────────────────────────────────────[m
[32m+SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)"[m
[32m+[m
[32m+if [ -d "$SCRIPT_DIR/dot_config" ] && [ -d "$SCRIPT_DIR/.git" ]; then[m
[32m+  echo ":: Applying dotfiles from $SCRIPT_DIR..."[m
[32m+  chezmoi init --apply "$SCRIPT_DIR" || true[m
[32m+elif [ -d "$HOME/.local/share/chezmoi/dot_config" ]; then[m
[32m+  echo ":: Applying dotfiles..."[m
[32m+  chezmoi apply || true[m
[32m+else[m
[32m+  REPO_URL="https://github.com/Sultonov-557/dotfiles.git"[m
[32m+  echo ":: Cloning dotfiles from $REPO_URL..."[m
[32m+  chezmoi init --apply "$REPO_URL" || true[m
[32m+fi[m
[32m+[m
[32m+echo ""[m
[32m+echo ":: Done! If any run_once scripts failed (e.g. sudo), re-run: chezmoi apply"[m
[32m+echo ""[m
[32m+echo ":: Post-install checklist:"[m
[32m+echo "::  1. Wallpapers — run_once_install-wallpaper.sh downloads defaults"[m
[32m+echo "::  2. Browser CSS — run_once_after_setup-firefox-chrome.sh deploys theme"[m
[32m+echo "::  3. Noctalia QuickShell — install manually from github.com/cloudmanic/noctalia"[m
[32m+echo "::     Then: qs -c noctalia-shell to start the shell/bar/control center"[m
[32m+echo "::  4. Systemd user services — enable with:"[m
[32m+echo "::     systemctl --user enable --now hyprpaper polkit-gnome"[m
[32m+echo "::  5. Set up GPG keys if needed: gpg --full-generate-key"[m
