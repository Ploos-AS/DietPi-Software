# DietPi-Software

Community software profiles and installers for DietPi systems.

This repository is independent from the upstream DietPi source tree. It provides reusable software items and role profiles which install on top of a standard DietPi system.

## Goals

- Keep hardware support separate from software profiles.
- Support multiple DietPi architectures where practical.
- Make installs repeatable, auditable and removable.
- Keep software items independent so mature integrations can later be proposed upstream where appropriate.
- Provide higher-level profiles which compose multiple software items into useful system roles.

## Initial scope

The first planned family is honeypots and deception services, with lightweight targets suitable for constrained SBCs such as Orange Pi Zero / Zero LTS.

The repository is intentionally broader than honeypots. Future software families may include security, monitoring, networking, radio/HAM, retro-computing and appliance-oriented services.

## Repository layout

```text
software/      Individual software items
profiles/      Role/profile compositions
lib/           Shared installer and lifecycle code
tests/         Validation and integration tests
docs/          User and contributor documentation
tools/         Development and maintenance tooling
```

A **software item** installs and manages one independently useful application or service.

A **profile** combines one or more software items and configuration choices into a reusable DietPi system role.

Repository-local identifiers are not official DietPi software IDs.

## Platform model

```text
Official DietPi
      |
      v
DietPi-Software
      |
      +-- software items
      +-- profiles
      +-- shared lifecycle framework
```

DietPi-Software is not a DietPi fork. Board support belongs upstream in DietPi. In particular, Orange Pi Zero / Zero LTS support is developed separately and is not embedded in this repository.

Software should remain hardware-independent unless a technical requirement makes that impossible. Orange Pi Zero / Zero LTS is intended to become the first physically qualified constrained-SBC target, not the only supported platform.

## Planned first family: honeypots

Initial candidates include:

- OpenCanary
- Cowrie
- Heralding
- Dionaea
- Conpot

The project will prefer lightweight individual services on constrained hardware rather than assuming a large all-in-one honeypot distribution.

## Development principles

Software integrations should converge on a consistent lifecycle:

```text
install -> status -> remove
```

Install operations should be idempotent where practical. Network exposure, ports, privileges, log locations and persistent data must be documented. Removal must not silently destroy user data.

See [docs/PROFILE_SPEC.md](docs/PROFILE_SPEC.md) for the initial specification.

## Roadmap

M0 establishes the repository, scope, directory model, licensing and validation baseline.

M1 provides the executable framework: validated manifests, DietPi/platform detection, compatibility preflight, shared installer helpers, lifecycle state/logging and automated validation.

M1 framework implementation is complete. M2 introduces the first real software integrations.

See [ROADMAP.md](ROADMAP.md).

## Upstream relationship

This project complements DietPi rather than replacing it. Mature integrations which are broadly useful may be proposed to DietPi upstream separately.

Ploos-specific profiles and compositions can remain here while continuing to consume standard DietPi installations.

## License

Project code and documentation in this repository are licensed under **GPL-2.0-or-later**, following DietPi's licensing model where applicable.

Third-party applications installed by this project retain their own upstream licenses. See [LICENSE](LICENSE).

<!-- CI qualification probe: exercises pull_request validation before M2.1 gate. -->
