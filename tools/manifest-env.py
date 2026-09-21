#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-or-later
import json
import shlex
import sys

if len(sys.argv) != 2:
    raise SystemExit("usage: manifest-env.py <manifest.json>")

data = json.load(open(sys.argv[1], encoding="utf-8"))
mapping = {
    "DPS_ARCHITECTURES": " ".join(data.get("architectures", [])),
    "DPS_DEBIAN_CODENAMES": " ".join(data.get("debian_codenames", [])),
    "DPS_MIN_RAM_MIB": str(data.get("min_ram_mib", 0)),
    "DPS_MIN_STORAGE_MIB": str(data.get("min_storage_mib", 0)),
    "DPS_REQUIRES_CONTAINER": data.get("container", "none"),
    "DPS_REQUIRED_COMMANDS": " ".join(data.get("commands", [])),
    "DPS_REQUIRED_CAPABILITIES": " ".join(data.get("capabilities", [])),
}
for key, value in mapping.items():
    print(f"{key}={shlex.quote(value)}")
