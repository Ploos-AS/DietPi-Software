#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
export DPS_STATE_ROOT="$TMP/state"
export DPS_LOG_ROOT="$TMP/log"

source "$ROOT/lib/common.sh"
source "$ROOT/lib/lifecycle.sh"

dps_write_state example installing
[[ $(dps_read_state example) == installing ]]
dps_write_state example installed
[[ $(dps_read_state example) == installed ]]

cat > "$TMP/pass" <<'EOF'
#!/bin/bash
echo lifecycle-pass
EOF
chmod +x "$TMP/pass"
dps_run_logged example install "$TMP/pass"
grep -q lifecycle-pass "$DPS_LOG_ROOT/example.log"

cat > "$TMP/fail" <<'EOF'
#!/bin/bash
echo lifecycle-fail
exit 7
EOF
chmod +x "$TMP/fail"
set +e
dps_run_logged example install "$TMP/fail"
rc=$?
set -e
[[ $rc == 7 ]]
grep -q lifecycle-fail "$DPS_LOG_ROOT/example.log"

echo "Lifecycle state/log tests passed."
