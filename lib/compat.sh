#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later

dps_mem_mib() { awk '/^MemTotal:/ { print int($2 / 1024); exit }' /proc/meminfo; }
dps_free_mib() { local path=${1:-/}; df -Pm "$path" | awk 'NR==2 { print $4 }'; }
dps_has_command() { command -v "$1" >/dev/null 2>&1; }
dps_check_arch() { local current=$1 allowed=$2; [[ " $allowed " == *" $current "* ]]; }
dps_check_minimum() { local actual=$1 required=$2; (( actual >= required )); }
dps_port_available() { ! ss -H -lntu 2>/dev/null | awk '{print $5}' | grep -Eq "[:.]$1$"; }

dps_check_capability() {
	case $1 in
		root) (( EUID == 0 )) ;;
		systemd) [[ -d /run/systemd/system ]] ;;
		ipv4) ip -4 addr show scope global 2>/dev/null | grep -q 'inet ' ;;
		ipv6) ip -6 addr show scope global 2>/dev/null | grep -q 'inet6 ' ;;
		*) dps_die "Unknown capability requirement: $1" ;;
	esac
}

dps_check_compatibility() {
	local architectures=${DPS_ARCHITECTURES:-} codenames=${DPS_DEBIAN_CODENAMES:-}
	local min_ram=${DPS_MIN_RAM_MIB:-0} min_storage=${DPS_MIN_STORAGE_MIB:-0}
	local requires_container=${DPS_REQUIRES_CONTAINER:-none}
	local required_commands=${DPS_REQUIRED_COMMANDS:-}
	local capabilities=${DPS_REQUIRED_CAPABILITIES:-}
	local ports=${DPS_REQUIRED_PORTS:-}
	local arch codename ram disk cmd capability port

	arch=$(dps_detect_arch); codename=$(dps_detect_debian)
	ram=$(dps_mem_mib); disk=$(dps_free_mib /)

	dps_log "Preflight: architecture=$arch Debian=$codename RAM=${ram}MiB free-storage=${disk}MiB"
	[[ -z $architectures ]] || dps_check_arch "$arch" "$architectures" || dps_die "Unsupported architecture: $arch (supported: $architectures)"
	[[ -z $codenames ]] || [[ " $codenames " == *" $codename "* ]] || dps_die "Unsupported Debian release: $codename (supported: $codenames)"
	dps_check_minimum "$ram" "$min_ram" || dps_die "Insufficient RAM: ${ram} MiB available, ${min_ram} MiB required"
	dps_check_minimum "$disk" "$min_storage" || dps_die "Insufficient storage: ${disk} MiB free, ${min_storage} MiB required"

	for cmd in $required_commands; do dps_has_command "$cmd" || dps_die "Required command is missing: $cmd"; done
	for capability in $capabilities; do dps_check_capability "$capability" || dps_die "Required capability is unavailable: $capability"; done
	for port in $ports; do dps_port_available "$port" || dps_die "Required TCP/UDP port is already in use: $port"; done

	case $requires_container in
		none|'') ;;
		docker) dps_has_command docker || dps_die 'Docker is required.' ;;
		podman) dps_has_command podman || dps_die 'Podman is required.' ;;
		any) (dps_has_command docker || dps_has_command podman) || dps_die 'Docker or Podman is required.' ;;
		*) dps_die "Unknown container requirement: $requires_container" ;;
	esac
	dps_log 'Preflight: PASS'
}
