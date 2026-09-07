# `debian-config-server-hardening`

Headless server hardening package built on top of `debian-config-system-hardening`.

## Overview

This package enforces network stack protections and disables unnecessary daemons
across headless server nodes. It deploys configuration snippets into
`/usr/lib/sysctl.d/60-server-hardening.conf` following the vendor configuration
model.

## Hardening Applied

* **Storage Restrictions:** Applies strict `noexec`, `nosuid`, and `nodev` mount
  options to `/tmp` and `/dev/shm` via `/etc/fstab`.
* **Process Privacy:** Enforces `hidepid=2` on `/proc` to prevent users from
  viewing processes owned by other accounts.
* **System Target:** Enforces `multi-user.target` as the default system state,
  avoiding graphical overhead.
* **Network Security:** Enables strict Reverse Path Filtering (`rp_filter`),
  disables ICMP redirects (both send and accept), and drops source-routed packets.
* **Execution Control:** Disables SysRq magic key combinations
  (`kernel.sysrq = 0`).
* **Service Trimming:** Automatically stops and disables `exim4`, `cups`, and
  `avahi-daemon` on install if present.
* **Base Dependencies:** Requires `debian-config-system-hardening` for core OS
  protections (PAM, login.defs, statoverrides).

## Directory Structure

<!-- markdownlint-disable line-length -->
```text
debian-config-server-hardening/
├── README.md
├── LICENSE.md
├── debian/
│   ├── changelog
│   ├── control
│   ├── install
│   ├── postinst
│   ├── postrm
│   └── rules
└── usr/
    └── lib/
        └── sysctl.d/
            └── 60-server-hardening.conf
```
<!-- markdownlint-enable -->

## Verification

Check active mount options and process privacy configuration:

```bash
findmnt /tmp
findmnt /dev/shm
findmnt /proc
sysctl net.ipv4.conf.all.rp_filter net.ipv4.conf.all.accept_redirects kernel.sysrq
```

## Building

Build the package using debuild:

```bash
# Using debuild directly inside the package folder:
debuild -us -uc -b

# Or using the build script from repository root:
./build.sh system-hardening
```
