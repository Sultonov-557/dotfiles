#!/usr/bin/env bash
# =============================================================================
# run_once_after_setup-adguardhome.sh
# Post-install setup for AdGuardHome: enable systemd service, deploy config.
# Run manually after: sudo pacman -S adguardhome
# =============================================================================
set -euo pipefail

# Paths
CONFIG_SRC="$HOME/.config/AdGuardHome/AdGuardHome.yaml"
CONFIG_DST="/etc/AdGuardHome.yaml"
SERVICE="adguardhome.service"

if ! command -v adguardhome &>/dev/null; then
  echo ":: AdGuardHome not installed. Run: sudo pacman -S adguardhome"
  exit 1
fi

# Deploy config to /etc/ (needs sudo)
if [ -f "$CONFIG_SRC" ]; then
  echo ":: Deploying AdGuardHome config to $CONFIG_DST..."
  sudo install -m 644 -o root -g root "$CONFIG_SRC" "$CONFIG_DST"
  echo ":: Config deployed"
else
  echo ":: No config found at $CONFIG_SRC, skipping"
fi

# Bind to port 53 — setcap to avoid needing root for DNS
# (systemd service handles this via AmbientCapabilities, but setcap is belt-and-suspenders)
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/adguardhome 2>/dev/null || true

# Enable and start the service
echo ":: Enabling and starting $SERVICE..."
sudo systemctl enable --now "$SERVICE" || {
  echo ":: Service failed to start. Check: journalctl -u $SERVICE -n 50"
  exit 1
}

echo ":: AdGuardHome is running!"
echo ":: Admin UI: http://localhost:9000"
echo ":: DNS:     127.0.0.1:53"
echo ""
echo ":: Set system DNS resolver:"
echo "   sudo resolvectl dns    lo 127.0.0.1"
echo "   sudo resolvectl domain lo ~."
echo "   sudo resolvectl dnssec lo allow-downgrade"
echo "   sudo systemctl restart systemd-resolved"
