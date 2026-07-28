#!/usr/bin/env bash
# Enable core system services on fresh install
# NOTE: Run via `chezmoi apply` or manually
set -euo pipefail

echo ":: Enabling services..."

# NOTE: unbound, nginx, and vaultwarden are intentionally NOT auto-enabled.
# - unbound binds port 53 and conflicts with adguardhome (also DNS) unless
#   scoped to 127.0.0.1/::1 like nixul's module does — enable manually once
#   that's configured, matching the existing `setup-dns` step in TODO.md.
# - nginx needs real site/cert config first (nixul's version also generates
#   an internal CA); enable manually once that's set up.
# - vaultwarden isn't in packages.txt yet (uncertain official/AUR status,
#   see packages.txt comments) so there's nothing to enable here yet.
services=(
  NetworkManager
  bluetooth
  cups
  ufw
  docker
  libvirtd
  fail2ban
  sshd
)

for svc in "${services[@]}"; do
  if systemctl list-unit-files "${svc}.service" &>/dev/null; then
    sudo systemctl enable --now "${svc}.service"
    echo "  ✓ ${svc}"
  else
    echo "  ⚠ ${svc} not found, skipping"
  fi
done

echo ":: Services enabled."
