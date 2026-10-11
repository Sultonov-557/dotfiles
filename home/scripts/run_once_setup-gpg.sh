#!/usr/bin/env bash
# Basic GPG agent configuration
set -euo pipefail

GNUPG_DIR="$HOME/.gnupg"
AGENT_CONF="$GNUPG_DIR/gpg-agent.conf"

if [ -f "$AGENT_CONF" ]; then
  echo ":: gpg-agent.conf already exists, skipping"
  exit 0
fi

echo ":: Setting up GPG agent config..."
mkdir -p "$GNUPG_DIR"
chmod 700 "$GNUPG_DIR"

cat > "$AGENT_CONF" << 'EOF'
# GPG Agent configuration
# Cache PIN for 1 hour
default-cache-ttl 3600
max-cache-ttl 7200

# Use pinentry-tty (works in terminal)
pinentry-program /usr/bin/pinentry-tty

# Enable SSH support
enable-ssh-support

# Write to systemd environment for SSH
write-env-file "$HOME/.gnupg/gpg-agent.env"
EOF

chmod 600 "$AGENT_CONF"
echo ":: GPG agent config created at $AGENT_CONF"
echo ":: To generate a key: gpg --full-generate-key"
