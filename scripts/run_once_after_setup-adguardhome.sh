#!/usr/bin/env bash
# =============================================================================
# run_once_after_setup-adguardhome.sh
# Post-install setup for AdGuardHome: enable systemd service, deploy config.
# Run manually after: sudo pacman -S adguardhome
# =============================================================================
set -euo pipefail

# Paths
CONFIG_SRC="$HOME/.config/AdGuardHome/AdGuardHome.yaml"
# The systemd unit runs `adguardhome -w /var/lib/adguardhome`, so AdGuardHome
# reads/writes its config at $CONFIG_DST below — NOT /etc/AdGuardHome.yaml.
# (An earlier version of this script deployed to /etc/AdGuardHome.yaml, which
# AdGuardHome never reads; the daemon silently fell back to a config it
# generated itself via the setup wizard, so the tracked dotfiles config and
# the live one drifted apart — e.g. DNS port staying at the wizard's default
# of 54 instead of this file's 53.)
CONFIG_DST="/var/lib/adguardhome/AdGuardHome.yaml"
SERVICE="adguardhome.service"

if ! command -v adguardhome &>/dev/null; then
  echo ":: AdGuardHome not installed. Run: sudo pacman -S adguardhome"
  exit 1
fi

# Deploy config (needs sudo), but only on first install: once AdGuardHome has
# run, this file also holds runtime state (TLS certs, stats, filter lists,
# hashed passwords) that a blind overwrite would destroy. This guard also
# matters because editing this script changes its content hash, which makes
# chezmoi's run_once tracking re-run it — without the guard that would
# clobber a live, already-configured install the next time `chezmoi apply` runs.
if [ -f "$CONFIG_DST" ]; then
  echo ":: $CONFIG_DST already exists (AdGuardHome already configured), leaving it alone"
elif [ -f "$CONFIG_SRC" ]; then
  echo ":: Deploying AdGuardHome config to $CONFIG_DST..."
  sudo install -d -o adguardhome -g adguardhome /var/lib/adguardhome
  sudo install -m 644 -o adguardhome -g adguardhome "$CONFIG_SRC" "$CONFIG_DST"
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
echo ":: To make it the actual system default resolver (NetworkManager +"
echo ":: systemd-resolved otherwise bypasses it and forwards straight to your"
echo ":: DHCP-provided DNS), run once more, persists across reboots:"
echo ""
echo "   # Free port 53 from systemd-resolved's stub so there's no ambiguity"
echo "   sudo mkdir -p /etc/systemd/resolved.conf.d"
echo "   printf '[Resolve]\nDNSStubListener=no\n' | sudo tee /etc/systemd/resolved.conf.d/adguardhome.conf"
echo "   sudo systemctl restart systemd-resolved"
echo ""
echo "   # Point NetworkManager's active connection at AdGuardHome directly"
echo "   CONN=\$(nmcli -t -f NAME connection show --active | head -1)"
echo "   sudo nmcli connection modify \"\$CONN\" ipv4.dns 127.0.0.1 ipv4.ignore-auto-dns yes"
echo "   sudo nmcli connection modify \"\$CONN\" ipv6.dns ::1 ipv6.ignore-auto-dns yes"
echo "   sudo nmcli connection up \"\$CONN\""
