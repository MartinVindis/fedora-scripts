#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

SECONFIG="/etc/selinux/config"

echo "Disabling SELinux..."

# Modify SELinux config to disable it
if grep -q "^SELINUX=" "$SECONFIG"; then
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' "$SECONFIG"
else
    echo "SELINUX=disabled" >> "$SECONFIG"
fi

echo "SELinux is now disabled. A reboot is required for changes to take effect."

