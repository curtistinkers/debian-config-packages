# `zram` configuration package

This package contains highly-opinionated scripts, configuration, and systemd unit
files to quickly deploy `zram` swap using the `systemd-zram-generator` package
on Debian Linux.

In particular, it is meant to assist the user in quickly deploying zram along
with a write-back device for huge and idle pages.

## Resources

- [zram article on Arch Wiki](https://wiki.archlinux.org/title/Zram)
- [zram Linux kernel docs](https://docs.kernel.org/admin-guide/blockdev/zram.html)
