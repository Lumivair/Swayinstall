#!/bin/bash

# Update system
apt update && apt upgrade -y

# Install Sway (Compositor)
echo "Installing Sway..."
apt install -y sway

# Install Waybar (Panel)
echo "Installing Waybar..."
apt install -y waybar

# Install SDDM (Login Manager)
echo "Installing SDDM..."
apt install -y sddm
systemctl enable sddm

# Install Fuzzel (Application Launcher)
echo "Installing Fuzzel..."
apt install -y fuzzel

# Install Nemo (File Manager)
echo "Installing Nemo..."
apt install -y nemo

# Install Foot (Terminal Emulator)
echo "Installing Foot..."
apt install -y foot

# Install PipeWire (Audio System)
echo "Installing PipeWire..."
apt install -y pipewire pipewire-pulse wireplumber
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber

# Install Mako (Notification Daemon)
echo "Installing Mako..."
apt install -y mako-notifier

# Install Swaybg (Wallpaper Setter)
echo "Installing Swaybg..."
apt install -y swaybg

# Create Configuration Directories
echo "Setting up configuration files..."
mkdir -p ~/.config/{sway,waybar,mako,foot}

# Configure Sway
echo "Configuring Sway..."
cat > ~/.config/sway/config <<EOF
# Sway Configuration File
set \$mod Mod4

# Terminal
bindsym \$mod+Return exec foot

# Launcher
bindsym \$mod+d exec fuzzel

# Close focused window
bindsym \$mod+Shift+q kill

# Reload configuration
bindsym \$mod+Shift+c reload

# Floating toggle
bindsym \$mod+Shift+space floating toggle

# Exit Sway
bindsym \$mod+Shift+e exec "swaymsg exit"

# Wallpaper
exec swaybg -i /usr/share/backgrounds/default.jpg

# Launch Waybar
exec waybar

# Start Mako
exec mako
EOF

# Configure Waybar
echo "Configuring Waybar..."
cat > ~/.config/waybar/config <<EOF
{
  "layer": "top",
  "modules-left": ["workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["cpu", "memory", "network", "pulseaudio"]
}
EOF

cat > ~/.config/waybar/style.css <<EOF
* {
  font-family: "sans-serif";
  font-size: 12px;
}
EOF

# Configure Mako
echo "Configuring Mako..."
cat > ~/.config/mako/config <<EOF
font=monospace 12
default-timeout=5000
border-size=2
background-color=#1e1e2e
text-color=#ffffff
EOF

# Configure Foot
echo "Configuring Foot..."
cat > ~/.config/foot/foot.ini <<EOF
[foot]
font=monospace 12
scrollback-lines=10000
EOF

# Set Default Session in SDDM
echo "Configuring SDDM for Sway..."
mkdir -p /etc/sddm.conf.d
bash -c 'cat > /etc/sddm.conf.d/wayland.conf' <<EOF
[Wayland]
Session=sway
EOF

# Finishing Up
echo "Installation and configuration complete! Reboot your system to start the Sway session."
