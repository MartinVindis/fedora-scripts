#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Define the config file URL and destination path
CONFIG_URL="https://raw.githubusercontent.com/xerolinux/xero-layan-git/refs/heads/main/Configs/Home/.config/fastfetch/config.jsonc"  # Replace with the actual URL
CONFIG_DEST="$HOME/.config/fastfetch/config.jsonc"

echo "Installing Fastfetch..."
dnf install -y fastfetch

# Generate a default config file
echo "Generating Fastfetch configuration..."
fastfetch --gen-config

# Download the custom configuration file
echo "Downloading custom Fastfetch configuration..."
mkdir -p "$HOME/.config/fastfetch"
curl -fsSL "$CONFIG_URL" -o "$CONFIG_DEST"

echo "Fastfetch setup complete!"
