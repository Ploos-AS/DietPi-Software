# Endlessh

Endlessh is a lightweight SSH tarpit which slowly sends an endless SSH banner.

This integration uses the Debian package and systemd service rather than
maintaining a private Endlessh build.

## Default

The DietPi-Software integration uses port **2222** by default. It deliberately
does not take over port 22, since doing so could lock the administrator out of
the real SSH service.

Configuration is stored in `/etc/endlessh/config`.

To select another free unprivileged port (1024-65535) for the initial install:

```sh
ENDLESSH_PORT=2222 dietpi-software-extra install endlessh
```

If an existing `/etc/endlessh/config` is present, it is preserved and its configured `Port` value is used for the post-install listener check. `ENDLESSH_PORT` only controls creation of a new configuration.

Moving the real SSH service and exposing Endlessh on port 22 requires a separate, explicit privileged-port setup and is not performed automatically.

## Lifecycle

```sh
dietpi-software-extra check endlessh
dietpi-software-extra install endlessh
dietpi-software-extra status endlessh
dietpi-software-extra remove endlessh
```

Removal preserves `/etc/endlessh` to avoid silently deleting administrator
configuration.

## Upstream

https://github.com/skeeto/endlessh
