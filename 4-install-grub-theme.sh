#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Define the theme repository and temp directory
THEME_REPO="https://github.com/vinceliuice/grub2-themes.git"
TEMP_DIR="/tmp/grub2-themes"

echo "Downloading GRUB theme..."
rm -rf "$TEMP_DIR"
git clone "$THEME_REPO" "$TEMP_DIR"

# Navigate to the downloaded folder and install the theme
cd "$TEMP_DIR" || exit
echo "Installing GRUB theme..."
sudo ./install.sh

# Modify GRUB to enable graphical mode
GRUB_CONFIG="/etc/default/grub"

echo "Configuring GRUB for graphical theme..."
if grep -q '^GRUB_TERMINAL_OUTPUT=' "$GRUB_CONFIG"; then
    sed -i 's/^GRUB_TERMINAL_OUTPUT=.*/GRUB_TERMINAL_OUTPUT="gfxterm"/' "$GRUB_CONFIG"
else
    echo 'GRUB_TERMINAL_OUTPUT="gfxterm"' >> "$GRUB_CONFIG"
fi

# Update GRUB configuration
echo "Updating GRUB..."
grub2-mkconfig -o /etc/grub2.cfg

echo "GRUB theme installation complete! A reboot is recommended."
