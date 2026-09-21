#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
export DPS_TEST_STATE="$TMP/state"

# Test shared platform helpers without requiring a DietPi host.
# shellcheck source=../lib/common.sh
source "$ROOT/lib/common.sh"
arch=$(dps_detect_arch)
[[ -n $arch ]]
codename=$(dps_detect_debian)
[[ -n $codename ]]

# Validate a complete fixture manifest.
python3 "$ROOT/tools/validate-manifests.py" --root "$ROOT/tests/fixtures"

# Exercise lifecycle semantics directly. The production CLI requires root for
# mutating operations by design; the fixture verifies idempotency separately.
bash "$ROOT/tests/fixtures/example/install"
bash "$ROOT/tests/fixtures/example/install"
bash "$ROOT/tests/fixtures/example/status"
bash "$ROOT/tests/fixtures/example/remove"
! bash "$ROOT/tests/fixtures/example/status"
bash "$ROOT/tests/fixtures/example/remove"

echo "Framework tests passed."
