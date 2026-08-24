# ZRAM Configuration Package

This package contains highly-opinionated script, configuration, and systemd unit
files to for quickly deploy ZRAM swap using the `systemd-zram-generator` package
on Debian Linux.

In particular, it is meant to assist the user in quickly deploying zram along
with a write-back device for idle and huge non-compressible pages.
