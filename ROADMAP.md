# Roadmap

## M0 — Foundation

- Repository purpose and scope
- GPL-2.0-or-later license
- Software/profile directory model
- Initial profile specification
- Architecture and lifecycle principles
- CI baseline

## M1 — Framework

- Manifest validation
- Shared installer helpers
- install/status/remove lifecycle
- DietPi and Debian detection
- Architecture detection
- Per-item compatibility and resource requirements
- Idempotency tests
- Logging and error handling

## M2 — First software family: honeypots

Planned software items:

- OpenCanary — lightweight multi-service honeypot
- Cowrie — SSH/Telnet honeypot
- Heralding — credential-capturing honeypot for multiple protocols
- Dionaea — network service/malware interaction honeypot
- Conpot — ICS/SCADA honeypot
- Endlessh — lightweight SSH tarpit
- T-Pot — comprehensive multi-honeypot platform

DietPi-Software is a general DietPi project. Honeypot availability is determined
per software item from its actual platform and resource requirements, rather
than by targeting one particular SBC.

Each software item should declare compatibility metadata where applicable:

- supported architectures (armhf, arm64, amd64, etc.)
- supported DietPi/Debian releases
- minimum RAM
- minimum storage
- native/container requirements
- required kernel or system capabilities
- network/port requirements

Installers should detect unsupported hosts and fail clearly before making
system changes.

## M3 — Profiles

Compose software items into reusable roles, for example:

- honeypot-minimal
- honeypot-ssh
- honeypot-multiservice
- central-collector

Profiles must evaluate the compatibility requirements of all included software
items before installation.

## M4 — Multi-platform qualification

Qualification is capability-based rather than tied to one board family.

Planned coverage includes:

- DietPi armhf
- DietPi arm64
- DietPi amd64
- constrained SBCs where applicable
- higher-resource SBCs and systems for demanding software such as T-Pot

Orange Pi Zero / Zero LTS can be used as an early physical armhf qualification
platform, but it does not define the scope of DietPi-Software.

## M5 — Additional software families

Potential families include security, monitoring, networking, radio/HAM,
retro-computing and appliance-oriented services.

## Upstream policy

Items which become mature and broadly useful may be proposed to DietPi
upstream separately. Ploos-specific profiles remain in this repository.
