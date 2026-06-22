#!/usr/bin/env bash
# Enable core system services on fresh install
# NOTE: Run via `chezmoi apply` or manually
set -euo pipefail

echo ":: Enabling services..."

services=(
  NetworkManager
  bluetooth
  cups
  ufw
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
