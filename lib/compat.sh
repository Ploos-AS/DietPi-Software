#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later

dps_mem_mib() {
	awk '/^MemTotal:/ { print int($2 / 1024); exit }' /proc/meminfo
}

dps_free_mib() {
	local path=${1:-/}
	df -Pm "$path" | awk 'NR==2 { print $4 }'
}

dps_has_command() {
	command -v "$1" >/dev/null 2>&1
}

dps_check_arch() {
	local current=$1 allowed=$2
	[[ " $allowed " == *" $current "* ]]
}

dps_check_minimum() {
	local actual=$1 required=$2
	(( actual >= required ))
}

dps_check_compatibility() {
	local architectures=${DPS_ARCHITECTURES:-}
	local min_ram=${DPS_MIN_RAM_MIB:-0}
	local min_storage=${DPS_MIN_STORAGE_MIB:-0}
	local requires_container=${DPS_REQUIRES_CONTAINER:-none}
	local arch ram disk

	arch=$(dps_detect_arch)
	ram=$(dps_mem_mib)
	disk=$(dps_free_mib /)

	[[ -z $architectures ]] || dps_check_arch "$arch" "$architectures" ||
		dps_die "Unsupported architecture: $arch (supported: $architectures)"
	dps_check_minimum "$ram" "$min_ram" ||
		dps_die "Insufficient RAM: ${ram} MiB available, ${min_ram} MiB required"
	dps_check_minimum "$disk" "$min_storage" ||
		dps_die "Insufficient storage: ${disk} MiB free, ${min_storage} MiB required"

	case $requires_container in
		none|'') ;;
		docker) dps_has_command docker || dps_die 'Docker is required.' ;;
		podman) dps_has_command podman || dps_die 'Podman is required.' ;;
		any)
			(dps_has_command docker || dps_has_command podman) ||
				dps_die 'Docker or Podman is required.'
			;;
		*) dps_die "Unknown container requirement: $requires_container" ;;
	esac
}
