#!/bin/sh
# /etc/profile.d/50-disable-coredump.sh
set -e

# Disable core dumps for all user shells
ulimit -S -c 0 >/dev/null 2>&1 || true
