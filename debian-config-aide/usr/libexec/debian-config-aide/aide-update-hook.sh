#!/bin/sh

# Define ANSI color escape codes
RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"

echo "${BOLD}${YELLOW}Updating AIDE baseline after APT transaction${RESET}"

# Run the AIDE update step
/usr/bin/aide -c /etc/aide/aide.conf --update
RET=$?

echo ""
echo "${BOLD}${YELLOW}--> Processing update results...${RESET}"

# AIDE returns 0-7 for standard file changes. 
if [ "${RET}" -le 7 ]; then
    echo "${BOLD}${GREEN}[+] Scan successful (Exit code: ${RET}).${RESET}"
    echo "${BOLD}${GREEN}[+] Committing new AIDE baseline database...${RESET}"

    cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db

    echo "${BOLD}${GREEN}[✓] Production database updated successfully!${RESET}"
    exit 0
else
    echo "${BOLD}${RED}[!] AIDE failed with a critical configuration or I/O error!${RESET}"
    echo "${RED}[!] AIDE return code was: ${RET}.${RESET}"
    exit 1
fi
