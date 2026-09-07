#!/bin/sh
# /etc/profile.d/50-default-umask.sh
set -e

# Set default security umask for interactive shells
umask 027
