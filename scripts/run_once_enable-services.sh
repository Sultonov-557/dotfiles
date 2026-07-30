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
# - postgresql is handled separately below: its unit does NOT auto-run
#   initdb (an earlier version of this comment claimed it did via
#   postgresql-check-db-dir — wrong, that script only checks and errors,
#   telling you to initdb manually; it doesn't do it for you). Needs
#   initdb before the service will start at all.
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

if command -v postgres &>/dev/null; then
  # sudo -iu (not su -l): only needs YOUR sudo password, not one for the
  # postgres OS account (which has no password set at all — su would need it).
  if sudo test ! -f /var/lib/postgres/data/PG_VERSION; then
    echo ":: Initializing PostgreSQL data directory..."
    sudo -iu postgres initdb --locale=C.UTF-8 --encoding=UTF8 -D /var/lib/postgres/data
  fi
  sudo systemctl enable --now postgresql.service
  echo "  ✓ postgresql"
fi

echo ":: Services enabled."
