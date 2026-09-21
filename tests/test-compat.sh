#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
# shellcheck source=../lib/common.sh
source "$ROOT/lib/common.sh"
# shellcheck source=../lib/compat.sh
source "$ROOT/lib/compat.sh"

arch=$(dps_detect_arch)
ram=$(dps_mem_mib)
disk=$(dps_free_mib /)

[[ -n $arch ]]
(( ram > 0 ))
(( disk > 0 ))
dps_check_arch "$arch" "$arch"
! dps_check_arch "$arch" "definitely-not-$arch"
dps_check_minimum 1024 512
! dps_check_minimum 256 512
dps_has_command sh
dps_check_capability root || [[ $EUID -ne 0 ]]
dps_port_available 65534 || true
! dps_has_command definitely-not-a-real-command-dps

DPS_ARCHITECTURES="$arch"
DPS_MIN_RAM_MIB=1
DPS_MIN_STORAGE_MIB=1
DPS_REQUIRES_CONTAINER=none
dps_check_compatibility

echo "Compatibility tests passed."
