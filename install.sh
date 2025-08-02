#!/usr/bin/env bash
sudo -v
curl -fsSL https://raw.githubusercontent.com/u1aryz/how-to-avahi-subdomain/refs/heads/main/avahi-publish-subdomain |
	sudo install -Dm755 /dev/stdin /usr/local/bin/avahi-publish-subdomain
curl -fsSL https://raw.githubusercontent.com/u1aryz/how-to-avahi-subdomain/refs/heads/main/avahi-subdomain%40.service |
	sudo install -Dm644 /dev/stdin /etc/systemd/system/avahi-subdomain@.service
