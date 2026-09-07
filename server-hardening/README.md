# `debian-config-server-hardening`

Headless server hardening package built on top of `debian-config-system-hardening`.

## Overview

This package enforces network stack protections and disables unnecessary daemons
across headless server nodes. It deploys configuration snippets into
`/usr/lib/sysctl.d/60-server-hardening.conf` following the vendor configuration
model.

## Hardening Applied

* **Network Security:** Enables strict Reverse Path Filtering (`rp_filter`),
    disables ICMP redirects (both send and accept), and drops source-routed packets.
* **Execution Control:** Disables SysRq magic key combinations
    (`kernel.sysrq = 0`).
* **Service Trimming:** Automatically disables `exim4`, `cups`, and
    `avahi-daemon` on install if present.
* **Base Dependencies:** Requires `debian-config-system-hardening` for core OS protections.

## Directory Structure

<!-- markdownlint-disable line-length -->
```text
debian-config-server-hardening/
├── README.md
├── LICENSE.md
├── debian/
│   ├── changelog
│   ├── control
│   ├── debian-config-server-hardening.install
│   ├── postinst
│   ├── postrm
│   └── rules
└── usr/
    └── lib/
        ├── sysctl.d/
        │   └── 60-server-hardening.conf
        └── systemd/
            └── system-preset/
                └── 50-debian-config-server-hardening.preset
```
<!-- markdownlint-enable -->

## Verification

Check active network sysctl settings:

```bash
sysctl net.ipv4.conf.all.rp_filter net.ipv4.conf.all.accept_redirects kernel.sysrq
```

## Building

Build the package using debuild:

```bash
debuild -us -uc -b
```
