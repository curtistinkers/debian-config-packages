# `debian-config-sshd`

Automated OpenSSH daemon hardening package based on Lynis security recommendations.

## Overview

This package deploys hardening settings through drop-in configuration snippets
in `/etc/ssh/sshd_config.d/`. It leaves base OS configuration files untouched
and relies on standard Debian package hooks for setup and maintenance.

## Hardening Applied

* **Access Control:** Restricts logins to members of the `ssh-users` adn `sudo`
    system groups.
* **Authentication:** Blocks root password login, disables empty passwords, and
    caps authentication retries.
* **Session Management:** Enforces client idle timeouts to drop inactive connections.
* **Lifecycle Automation:** Provisions the `ssh-users` group, validates syntax
    with `sshd -t`, and reloads `sshd` via `invoke-rc.d`.

## Directory Structure

<!-- markdownlint-disable line-length -->
```text
debian-config-sshd/
├── debian/
│   ├── control                      # Package metadata and dependencies (openssh-server, fail2ban)
│   ├── debian-config-sshd.install   # Installs sshd and fail2ban drop-in configs
│   ├── postinst                     # Group creation, syntax check, and service reloads
│   ├── postrm                       # Cleanup and admin notifications on purge
│   └── rules                        # Debhelper build targets
└── etc/
    ├── fail2ban/
    │   └── jail.d/
    │       └── 99-sshd.conf         # Fail2ban SSH jail configuration
    └── ssh/
        └── sshd_config.d/
            └── 99-hardening.conf    # OpenSSH hardening options
```
<!-- markdownlint-enable -->

## User Management

Grant SSH access by adding target users to the ssh-users group:

```bash
sudo usermod -aG ssh-users <username>
```

## Verification

Check configuration syntax and active settings:

```bash
# Validate config syntax
sudo sshd -t

# View active rules
sudo sshd -T | grep -E "(permitrootlogin|allowgroups|passwordauthentication)"

# Verify fail2ban SSH jail status
sudo fail2ban-client status sshd
```

## Building

Build the package using debuild:

```bash
debuild -us -uc -b
```
