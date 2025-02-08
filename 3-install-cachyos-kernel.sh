#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

echo "Enabling Copr repository for CachyOS kernel..."
dnf copr enable -y bieszczaders/kernel-cachyos

echo "Installing CachyOS kernel and related packages..."
dnf install -y \
    kernel-cachyos \
    kernel-cachyos-devel-matched \
    kernel-cachyos-headers

echo "Rebuilding kernel modules..."
akmods --rebuild

echo "CachyOS kernel installation complete! A reboot is recommended."
