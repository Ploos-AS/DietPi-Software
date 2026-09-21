#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
set -euo pipefail

ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
ITEM="$ROOT/software/endlessh"

python3 "$ROOT/tools/validate-manifests.py"
bash -n "$ITEM/install" "$ITEM/status" "$ITEM/remove"
shellcheck "$ITEM/install" "$ITEM/status" "$ITEM/remove"

python3 - "$ITEM/manifest.json" <<'PY'
import json, sys
m=json.load(open(sys.argv[1]))
assert m["id"] == "endlessh"
assert m["container"] == "none"
assert 2222 in m["ports"]
assert "systemd" in m["capabilities"]
assert "root" in m["capabilities"]
assert "systemctl" in m["commands"]
PY

grep -q 'ENDLESSH_PORT:-2222' "$ITEM/install"
grep -q '/etc/endlessh/config' "$ITEM/install"
grep -q 'systemctl enable --now endlessh.service' "$ITEM/install"
grep -q 'systemctl is-active --quiet endlessh.service' "$ITEM/install"
grep -q 'apt-get remove -y endlessh' "$ITEM/remove"
grep -q 'Configuration under /etc/endlessh is preserved' "$ITEM/remove"

echo "Endlessh integration tests passed."
