#!/usr/bin/env bash

# Avahi Subdomain Installer
# Installs avahi-publish-subdomain script and systemd service

set -euo pipefail

# Configuration
readonly BASE_URL="https://raw.githubusercontent.com/u1aryz/how-to-avahi-subdomain/refs/heads/main"
readonly SCRIPT_NAME="$(basename "$0")"

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly NC='\033[0m' # No Color

# File definitions: filename|permission|destination
readonly FILES=(
	"avahi-publish-subdomain|755|/usr/local/bin/avahi-publish-subdomain"
	"avahi-subdomain%40.service|644|/etc/systemd/system/avahi-subdomain@.service"
)

# Logging functions
log_info() {
	echo -e "${GREEN}[INFO]${NC} $*" >&2
}

log_error() {
	echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Check system requirements
check_requirements() {
	local missing_deps=()
	local required_commands=("curl" "sudo" "install")

	for cmd in "${required_commands[@]}"; do
		if ! command -v "$cmd" &>/dev/null; then
			missing_deps+=("$cmd")
		fi
	done

	if [[ ${#missing_deps[@]} -gt 0 ]]; then
		log_error "Missing required dependencies: ${missing_deps[*]}"
		exit 1
	fi
}

# Verify sudo access
verify_sudo() {
	log_info "Verifying sudo access..."
	if ! sudo -v; then
		log_error "Failed to obtain sudo privileges"
		exit 1
	fi
}

# Download and install a single file
install_file() {
	local file="$1"
	local mode="$2"
	local dest="$3"
	local url="${BASE_URL}/${file}"

	log_info "Installing ${file} to ${dest}"

	if ! curl -fsSL "$url" | sudo install -Dm"$mode" /dev/stdin "$dest"; then
		log_error "Failed to install ${file}"
		return 1
	fi

	log_info "Successfully installed ${dest}"
}

# Main installation function
install_files() {
	local failed_files=()

	for entry in "${FILES[@]}"; do
		IFS='|' read -r file mode dest <<<"$entry"

		if ! install_file "$file" "$mode" "$dest"; then
			failed_files+=("$file")
		fi
	done

	if [[ ${#failed_files[@]} -gt 0 ]]; then
		log_error "Failed to install: ${failed_files[*]}"
		exit 1
	fi
}

# Display usage information
show_usage() {
	cat >&2 <<-EOF
		Usage: $SCRIPT_NAME [OPTIONS]

		Install avahi-publish-subdomain script and systemd service.

		OPTIONS:
				-h, --help      Show this help message
				-v, --verbose   Enable verbose output

		EXAMPLES:
				$SCRIPT_NAME                # Install with default settings
				$SCRIPT_NAME --verbose      # Install with verbose output
	EOF
}

# Parse command line arguments
parse_args() {
	while [[ $# -gt 0 ]]; do
		case $1 in
		-h | --help)
			show_usage
			exit 0
			;;
		-v | --verbose)
			set -x
			shift
			;;
		*)
			log_error "Unknown option: $1"
			show_usage
			exit 1
			;;
		esac
	done
}

# Main function
main() {
	parse_args "$@"

	log_info "Starting Avahi Subdomain installation..."

	check_requirements
	verify_sudo
	install_files

	log_info "Installation completed successfully!"
	log_info "You can now use: sudo systemctl enable --now avahi-subdomain@<subdomain>.service"
}

# Run main function with all arguments
main "$@"
