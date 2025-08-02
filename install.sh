#!/usr/bin/env bash
set -euo pipefail
set -x
sudo -v

BASE_URL="https://raw.githubusercontent.com/u1aryz/how-to-avahi-subdomain/refs/heads/main"

# Format: filename|permission|dist
FILES=(
	"avahi-publish-subdomain|755|/usr/local/bin/avahi-publish-subdomain"
	"avahi-subdomain%40.service|644|/etc/systemd/system/avahi-subdomain@.service"
)

for entry in "${FILES[@]}"; do
	IFS='|' read -r FILE MODE DEST <<<"$entry"
	curl -fsSL "${BASE_URL}/${FILE}" | sudo install -Dm"${MODE}" /dev/stdin "${DEST}"
done
