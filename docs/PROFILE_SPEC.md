# Software and Profile Specification

## Concepts

A **software item** installs and manages one independently useful application
or service. A **profile** composes software items into a system role.

Repository-local identifiers are not official DietPi software IDs.

## Software item layout

```text
software/<id>/
├── manifest.json
├── install
├── status
├── remove
└── README.md
```

Lifecycle scripts are executable when implemented.

## Manifest v1

M1 uses JSON so manifests can be validated with Python's standard library
without adding a YAML dependency.

Required fields:

```json
{
  "id": "example",
  "name": "Example",
  "description": "Example service",
  "architectures": ["armhf", "arm64", "amd64"],
  "license": "SPDX-expression",
  "upstream": "https://example.invalid/"
}
```

Planned compatibility fields include DietPi/Debian constraints, minimum RAM,
minimum storage, container/native requirements, kernel capabilities and
network/port requirements.

The `id` must equal the software directory name.

## Lifecycle

Implemented items converge on:

```text
install -> status -> remove
```

Install must be idempotent where practical. Compatibility checks should run
before system changes. Removal must not silently destroy user data.

The M1 CLI is `tools/dietpi-software-extra`.

## Platform detection

Shared helpers in `lib/common.sh` detect DietPi, Debian codename and Debian
architecture. Individual software items must not hard-code an SBC model unless
the software genuinely requires one.

## Security

Services must not silently expose management interfaces or weaken the host.
Network ports, privileges, data collection, persistence and log paths must be
documented.

Honeypots must keep management access distinct from intentionally exposed
deception services.

## Profiles

Profiles will be implemented after the software-item lifecycle is stable.
They must validate the combined compatibility requirements of all included
items before installation.
