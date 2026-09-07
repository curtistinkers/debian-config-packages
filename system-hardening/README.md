# `debian-config-system-hardening`

Universal base system hardening package for Debian environments.

## Overview

This package deploys generic security settings to `/usr/lib/` following standard
vendor configuration practices. It leaves `/etc/` clear for local administrator
overrides and applies equally to servers, desktops, and containers without
breaking core functionality.

## Hardening Applied

* **Kernel Self-Protection:** Restricts symlink/hardlink exploitation and blocks
    regular/FIFO writes in sticky directories (`/tmp`).
* **Information Leak Prevention:** Hides kernel pointers from unprivileged users
    (`kptr_restrict`) and restricts `dmesg` buffer read access.
* **Core Dump Suppression:** Configures `systemd-coredump` to drop process core
    dumps to protect sensitive memory states from hitting disk.
* **Mandatory Access Control:** Declares a package dependency on `apparmor`.

## Directory Structure

<!-- markdownlint-disable line-length -->
```text
debian-config-system-hardening/
├── debian/
│   ├── changelog                            # Changelog
│   ├── control                              # Package metadata and dependencies
│   ├── install                              # Installs drop-in configs
│   ├── postinst                             # Post-installation hooks
│   ├── postrm                               # Post-removal hooks
│   └── rules                                # Debhelper build targets
└── usr/
    └── lib/
        ├── sysctl.d/
        │   └── 50-system-hardening.conf     # Kernel runtime protection options
        └── systemd/
            └── coredump.conf.d/
                └── 50-disable-coredump.conf # Core dump suppression rules
```
<!-- markdownlint-enable -->

## Verification

Confirm sysctl options and coredump settings are active:

```bash
# Verify kernel runtime settings
sysctl fs.protected_symlinks kernel.kptr_restrict kernel.dmesg_restrict

# Inspect active systemd coredump configuration
systemd-analyze cat-config systemd/coredump.conf
```

## Building

Build the package using debuild:

```bash
debuild -us -uc -b
```
