#!/usr/bin/env bash
set -Eeuo pipefail

echo "======================================"
echo "      Zeyad Monitor Uninstaller"
echo "======================================"

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this uninstaller as root."
    exit 1
fi

if dpkg-query -W -f='${db:Status-Status}' zeyad-monitor 2>/dev/null | grep -qx installed; then
    echo "Removing Zeyad Monitor..."
    apt-get remove -y zeyad-monitor
else
    echo "Zeyad Monitor is not installed."
fi

echo "Removing APT repository configuration..."
rm -f /etc/apt/sources.list.d/zeyad-monitor.list
rm -f /etc/apt/keyrings/zeyad-monitor.gpg

apt-get update

echo
echo "Zeyad Monitor has been removed."
