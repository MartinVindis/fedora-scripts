#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

echo "Installing USBGuard..."
dnf install -y usbguard

# Define config file paths
USBGUARD_CONFIG="/etc/usbguard/usbguard-daemon.conf"
USBGUARD_RULES="/etc/usbguard/rules.conf"

# Modify the configuration file to set ImplicitPolicyTarget=allow
echo "Configuring USBGuard..."
if grep -q "^ImplicitPolicyTarget=" "$USBGUARD_CONFIG"; then
    sed -i 's/^ImplicitPolicyTarget=.*/ImplicitPolicyTarget=allow/' "$USBGUARD_CONFIG"
else
    echo "ImplicitPolicyTarget=allow" >> "$USBGUARD_CONFIG"
fi

# Generate a policy and write it to rules.conf
echo "Generating USBGuard policy..."
usbguard generate-policy > "$USBGUARD_RULES"

# Block G27 Racing Wheel (modify existing rule if found)
echo "Blocking 'G27 Racing Wheel' in USBGuard rules..."
sed -i '/G27 Racing Wheel/s/^allow/block/' "$USBGUARD_RULES"

# Start and enable the USBGuard service
echo "Starting and enabling USBGuard..."
systemctl start usbguard.service
systemctl enable usbguard.service

echo "USBGuard setup complete!"
