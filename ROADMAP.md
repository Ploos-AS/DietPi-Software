# Roadmap

## M0 — Foundation

- Repository purpose and scope
- MIT license
- Software/profile directory model
- Initial profile specification
- Architecture and lifecycle principles
- CI baseline

## M1 — Framework

- Manifest validation
- Shared installer helpers
- install/status/remove lifecycle
- DietPi and architecture detection
- idempotency tests
- logging and error handling

## M2 — First software family: honeypots

Initial candidates:

- OpenCanary
- Cowrie
- Heralding
- Dionaea
- Conpot

Lightweight services should be qualified first on constrained SBCs.

## M3 — Profiles

Compose software items into reusable roles, for example:

- honeypot-minimal
- honeypot-ssh
- honeypot-multiservice
- central-collector

## M4 — Multi-platform qualification

Qualification tiers:

1. Physical Orange Pi Zero / Zero LTS
2. Other supported DietPi ARM systems
3. DietPi x86_64

## M5 — Additional software families

Potential families include security, monitoring, networking, radio/HAM,
retro-computing and appliance-oriented services.

## Upstream policy

Items which become mature and broadly useful may be proposed to DietPi
upstream separately. Ploos-specific profiles remain in this repository.
