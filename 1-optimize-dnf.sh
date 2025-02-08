#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

DNF_CONF="/etc/dnf/dnf.conf"

echo "Optimizing DNF configuration..."

# Check if the options already exist; if not, add them
if grep -q "^max_parallel_downloads=" "$DNF_CONF"; then
    sed -i 's/^max_parallel_downloads=.*/max_parallel_downloads=20/' "$DNF_CONF"
else
    echo "max_parallel_downloads=20" >> "$DNF_CONF"
fi

if grep -q "^fastestmirror=" "$DNF_CONF"; then
    sed -i 's/^fastestmirror=.*/fastestmirror=True/' "$DNF_CONF"
else
    echo "fastestmirror=True" >> "$DNF_CONF"
fi

echo "DNF optimization complete!"
