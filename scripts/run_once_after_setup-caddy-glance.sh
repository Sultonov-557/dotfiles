#!/usr/bin/env bash
# =============================================================================
# run_once_after_setup-caddy-glance.sh
# Post-install setup for Caddy (reverse proxy) + Glance (dashboard), run as
# user-level systemd services. Run manually after packages.txt has installed
# caddy (official) and glance-bin (AUR, via run_onchange_install-aur-packages).
# =============================================================================
set -euo pipefail

if ! command -v caddy &>/dev/null; then
  echo ":: caddy not installed. Run: sudo pacman -S caddy"
  exit 1
fi

if ! command -v glance &>/dev/null; then
  echo ":: glance not installed. Run: paru -S glance-bin"
  exit 1
fi

# The Caddyfile uses `tls internal` + bare hostnames (see
# dot_config/caddy/Caddyfile for why: glance.home/adguard.home are
# internal-only, no ACME cert to get), which binds both port 80 (auto
# redirect to https) and 443. caddy.service (dot_config/systemd/user/caddy.service)
# runs as this user, not root, so binding those needs this capability on the
# binary directly.
# NOTE: pacman strips capabilities on every caddy upgrade — re-run this script
# (or just the setcap line below) after any `caddy` package update.
echo ":: Granting caddy the capability to bind ports 80/443 without root..."
sudo setcap 'cap_net_bind_service=+ep' "$(command -v caddy)"

echo ":: Validating Caddyfile..."
caddy validate --config "$HOME/.config/caddy/Caddyfile"

echo ":: Enabling caddy and glance user services (not starting yet — start"
echo ":: them once you've confirmed the config, so a bad config doesn't loop"
echo ":: under Restart=on-failure)..."
systemctl --user enable caddy.service glance.service

echo ""
echo ":: Done. To start them and trust Caddy's local CA (order matters —"
echo ":: 'caddy trust' fetches the root cert from Caddy's own admin API, so"
echo ":: caddy has to be running first):"
echo ""
echo "   systemctl --user start caddy"
echo "   caddy trust    # installs Caddy's local CA — needs sudo, one-time"
echo "   systemctl --user start glance"
echo ""
echo ":: Without that 'caddy trust' step, glance.home/adguard.home will load"
echo ":: over https but with an untrusted-certificate warning."
echo ""
echo ":: These are user-level services — they stop when you log out unless"
echo ":: lingering is enabled:"
echo "   sudo loginctl enable-linger $USER"
echo ""
echo ":: glance.home / adguard.home resolve via AdGuardHome DNS rewrites, but"
echo ":: only once AdGuardHome is actually your system's DNS resolver — see"
echo ":: run_once_after_setup-adguardhome.sh's trailing instructions if you"
echo ":: haven't done that yet."
