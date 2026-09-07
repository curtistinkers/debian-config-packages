# `debian-config-system-hardening`

Universal base system hardening package for Debian environments.

## Overview

This package deploys generic security settings to `/usr/lib/` following standard
vendor configuration practices. It leaves `/etc/` clear for local administrator
overrides and applies equally to servers, desktops, and containers without
breaking core functionality.

## Hardening Applied

* **Kernel Self-Protection:** Restricts symlink/hardlink exploitation, blocks
    regular/FIFO writes in sticky directories (`/tmp`), and restricts TTY line
    discipline auto-loading (`dev.tty.ldisc_autoload`).
* **Information Leak & Process Protection:** Hides kernel pointers
    (`kptr_restrict`), restricts `dmesg` buffer access, and limits process
    tracing via `ptrace_scope`.
* **eBPF Hardening:** Restricts unprivileged eBPF execution
    (`kernel.unprivileged_bpf_disabled`) and enables JIT compiler constant blinding
    (`net.core.bpf_jit_harden`).
* **Password Policy & Authentication:** Enforces password complexity
    requirements (minimum length 12, character diversity, dictionary checks) via
    `libpam-pwquality` and declarative `pam-auth-update` profiles. Safe POSIX
    maintainer hooks enforce `login.defs` baselines (`UMASK 027`, SHA-512
    rounds, and password aging).
* **Core Dump Suppression:** Configures `systemd-coredump` to drop process core
    dumps to protect sensitive memory states from hitting disk.
* **Mandatory Access Control:** Declares a package dependency on `apparmor`.

## Directory Structure

<!-- markdownlint-disable line-length -->
```text
debian-config-system-hardening/
├── README.md
├── LICENSE.md
├── debian/
│   ├── changelog                                # Package version and revision history
│   ├── control                                  # Package metadata and dependencies
│   ├── install                                  # Installs drop-in configs
│   ├── postinst                                 # Post-installation hooks (login.defs, PAM, sysctl)
│   ├── postrm                                   # Post-removal hooks (PAM cleanup, sysctl reload)
│   └── rules                                    # Debhelper build targets
├── etc/
│   └── security/
│       └── pwquality.conf.d/
│           └── 50-system-hardening.conf         # Password complexity rules
└── usr/
    ├── lib/
    │   ├── sysctl.d/
    │   │   └── 50-system-hardening.conf        # Kernel runtime protection options
    │   └── systemd/
    │       └── coredump.conf.d/
    │           └── 50-disable-coredump.conf    # Core dump suppression rules
    └── share/
        └── pam-configs/
            └── system-hardening-pwquality       # Declarative pam-auth-update profile
```
<!-- markdownlint-enable -->

## Verification

Confirm sysctl options and coredump settings are active:

```bash
# Verify kernel runtime settings
sysctl fs.protected_symlinks kernel.kptr_restrict kernel.dmesg_restrict dev.tty.ldisc_autoload

# Inspect active systemd coredump configuration
systemd-analyze cat-config systemd/coredump.conf

# Verify login.defs modifications
grep -E "(SHA_CRYPT|UMASK)" /etc/login.defs

# Verify the PAM stack includes pwquality
grep pwquality /etc/pam.d/common-password

# Test password policy parsing with pwscore
echo "weakpass" | pwscore
# Output: Password is shorter than 12 characters
```

## Building

Build the package using debuild:

```bash
debuild -us -uc -b
```
