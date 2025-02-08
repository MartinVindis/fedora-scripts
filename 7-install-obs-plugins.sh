#!/bin/bash

# Ensure the script is run as root for system-wide installations
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Define paths
PIPEWIRE_PLUGIN_URL="https://github.com/dimtpap/obs-pipewire-audio-capture/releases/download/1.1.5/linux-pipewire-audio-1.1.5.tar.gz"
PIPEWIRE_PLUGIN_DEST="$HOME/.config/obs-studio/plugins/"
OBS_VKCAPTURE_REPO="https://github.com/nowrep/obs-vkcapture.git"

# Function to install PipeWire Audio Capture Plugin
install_pipewire_plugin() {
    echo "Downloading PipeWire Audio Capture plugin..."
    mkdir -p "$PIPEWIRE_PLUGIN_DEST"
    curl -L "$PIPEWIRE_PLUGIN_URL" -o /tmp/pipewire-audio.tar.gz

    echo "Extracting plugin to OBS config folder..."
    tar -xzf /tmp/pipewire-audio.tar.gz -C "$PIPEWIRE_PLUGIN_DEST"
    
    echo "PipeWire Audio Capture plugin installed successfully!"
}

# Function to install Game Capture Plugin from source
install_game_capture_plugin() {
    echo "Installing dependencies..."
    dnf install -y cmake libobs vulkan-loader mesa-libGL mesa-libEGL libX11 libxcb wayland-devel wayland-protocols

    echo "Cloning and building OBS Vulkan Capture..."
    git clone "$OBS_VKCAPTURE_REPO" /tmp/obs-vkcapture
    cd /tmp/obs-vkcapture || exit
    mkdir build && cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
    make -j$(nproc)
    make install

    echo "OBS Vulkan Capture plugin installed successfully!"
}

# Function to set OBS_VKCAPTURE environment variable
set_environment_variable() {
    ENV_FILE="/etc/environment"

    echo "Adding OBS_VKCAPTURE=1 to /etc/environment..."
    if ! grep -q "^OBS_VKCAPTURE=1" "$ENV_FILE"; then
        echo "OBS_VKCAPTURE=1" >> "$ENV_FILE"
        echo "Environment variable added!"
    else
        echo "OBS_VKCAPTURE=1 is already set."
    fi
}

# Run functions
install_pipewire_plugin
install_game_capture_plugin
set_environment_variable

echo "OBS plugins setup complete!"
