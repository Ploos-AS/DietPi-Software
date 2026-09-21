#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later

set -o errexit
set -o nounset
set -o pipefail

dps_log() { printf '[DietPi-Software] %s\n' "$*"; }
dps_die() { printf '[DietPi-Software] ERROR: %s\n' "$*" >&2; exit 1; }

dps_require_root() {
	(( EUID == 0 )) || dps_die 'This operation must be run as root.'
}

dps_detect_arch() {
	dpkg --print-architecture 2>/dev/null || uname -m
}

dps_detect_debian() {
	[[ -r /etc/os-release ]] || dps_die '/etc/os-release is missing.'
	. /etc/os-release
	printf '%s\n' "${VERSION_CODENAME:-unknown}"
}

dps_is_dietpi() {
	[[ -e /boot/dietpi/.version || -e /etc/.dietpi_hw_model_identifier || -d /DietPi ]]
}
