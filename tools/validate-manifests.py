#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-or-later

import argparse
import json
import pathlib
import sys

DEFAULT_ROOT = pathlib.Path(__file__).resolve().parents[1] / "software"
parser = argparse.ArgumentParser()
parser.add_argument("--root", type=pathlib.Path, default=DEFAULT_ROOT)
args = parser.parse_args()

REQUIRED = {
    "id": str, "name": str, "description": str, "architectures": list,
    "license": str, "upstream": str,
}
OPTIONAL_TYPES = {
    "min_ram_mib": int,
    "min_storage_mib": int,
    "container": str,
    "debian_codenames": list,
    "commands": list,
    "capabilities": list,
}
VALID_ARCH = {"armhf", "arm64", "amd64", "i386", "riscv64"}
VALID_CONTAINER = {"none", "docker", "podman", "any"}

errors = []
for manifest in sorted(args.root.glob("*/manifest.json")):
    try:
        data = json.loads(manifest.read_text())
    except Exception as exc:
        errors.append(f"{manifest}: invalid JSON: {exc}")
        continue
    for key, typ in REQUIRED.items():
        if key not in data:
            errors.append(f"{manifest}: missing {key}")
        elif not isinstance(data[key], typ):
            errors.append(f"{manifest}: {key} must be {typ.__name__}")
    for key, typ in OPTIONAL_TYPES.items():
        if key in data and not isinstance(data[key], typ):
            errors.append(f"{manifest}: {key} must be {typ.__name__}")
    if data.get("id") != manifest.parent.name:
        errors.append(f"{manifest}: id must match directory name")
    architectures = data.get("architectures", [])
    if not architectures:
        errors.append(f"{manifest}: architectures must not be empty")
    for arch in architectures:
        if arch not in VALID_ARCH:
            errors.append(f"{manifest}: unsupported architecture value: {arch}")
    if data.get("container", "none") not in VALID_CONTAINER:
        errors.append(f"{manifest}: invalid container requirement")
    for key in ("min_ram_mib", "min_storage_mib"):
        if key in data and data[key] < 0:
            errors.append(f"{manifest}: {key} must not be negative")

if errors:
    print("\n".join(errors), file=sys.stderr)
    sys.exit(1)
print("Manifest validation passed.")
