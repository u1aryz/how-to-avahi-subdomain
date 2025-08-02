# mDNS Subdomain Addition

A simple tool to add mDNS subdomains using Avahi.

## Overview

This project provides an easy way to add mDNS subdomains to your local network using Avahi. It allows you to create custom subdomains that can be resolved on your local network without requiring a DNS server.

## Requirements

- `avahi-publish` must be installed on your system
- systemd (for service management)

## Installation

Run the following command to install:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/u1aryz/how-to-avahi-subdomain/refs/heads/main/install.sh)"
```

## Usage

To register and start a subdomain service, use:

```bash
sudo systemctl enable --now avahi-subdomain@<SUBDOMAIN>.service
```

Replace `<SUBDOMAIN>` with your desired subdomain name.

### Example

```bash
sudo systemctl enable --now avahi-subdomain@myapp.service
```

This will create and start a service for the subdomain `myapp.hostname.local`.

### Check Service Status

To check the status of a subdomain service:

```bash
sudo systemctl status avahi-subdomain@<SUBDOMAIN>.service
```
