#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Enable RPM Fusion (for NVIDIA drivers and other software)
echo "Enabling RPM Fusion..."
dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install NVIDIA drivers
echo "Installing NVIDIA drivers..."
dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda


GRUB_CONFIG="/etc/default/grub"
GRUB_CMDLINE="nvidia.NVreg_EnableGpuFirmware=0"

echo "Disabling NVIDIA GSP Firmware..."

# Check if the option is already in GRUB_CMDLINE_LINUX
if grep -q "$GRUB_CMDLINE" "$GRUB_CONFIG"; then
    echo "NVIDIA GSP firmware is already disabled in GRUB."
else
    # Modify the GRUB_CMDLINE_LINUX line to include the option
    sed -i "/^GRUB_CMDLINE_LINUX=/ s/\"\$/ $GRUB_CMDLINE\"/" "$GRUB_CONFIG"
    echo "Added '$GRUB_CMDLINE' to GRUB_CMDLINE_LINUX."
fi

# Update GRUB configuration
echo "Updating GRUB..."
grub2-mkconfig -o /etc/grub2.cfg

echo "NVIDIA GSP firmware disabled. A reboot is required."