# Software and Profile Specification

## Concepts

A **software item** installs and manages one independently useful application
or service.

A **profile** composes one or more software items and configuration choices
into a system role.

This separation avoids treating profiles as unofficial DietPi software IDs.

## Software item layout

```text
software/<name>/
├── manifest
├── install
├── status
├── remove
└── README.md
```

Only the manifest is mandatory during M0. Lifecycle scripts become required
when an item is implemented.

## Profile layout

```text
profiles/<name>/
├── manifest
└── README.md
```

Profiles reference software items by their repository-local names.

## Manifest principles

The manifest format introduced during M1 must describe at least:

- stable repository-local identifier
- display name
- description
- supported architectures
- required DietPi/Debian constraints
- dependencies
- upstream project/source
- license information
- lifecycle capabilities

Repository-local identifiers are not official DietPi software IDs.

## Lifecycle

Implemented software items should converge toward:

```text
install -> status -> remove
```

Install operations should be idempotent where practical. Removal must avoid
deleting user data unless that behaviour is explicit and confirmed.

## Security

Software services must not silently expose management interfaces or weaken
the host configuration. Profiles which intentionally expose network services
must document ports, privilege requirements, data collection and log paths.

Honeypot profiles must keep the management plane distinct from intentionally
exposed deception services.

## Hardware

Software items should not depend on a particular SBC unless technically
necessary. Hardware qualification is metadata, not a reason to duplicate
software implementations.
