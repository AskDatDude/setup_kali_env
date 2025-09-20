#!/bin/bash
# Kali Linux Custom Environment Setup
# Alacritty + tmux + Arc-Dark + Roboto Thin + bash prompt
# Minimal Alacritty config using official alacritty-theme

set -e

echo "[*] Updating system..."
sudo apt update && sudo apt full-upgrade -y

echo "[*] Installing packages..."
sudo apt install -y alacritty tmux fonts-roboto git xfce4 xfce4-terminal

echo "[*] Setting Alacritty as default terminal..."
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50
sudo update-alternatives --config x-terminal-emulator <<< "1"

echo "[*] Applying Arc-Dark theme..."
xfconf-query -c xsettings -p /Net/ThemeName -s "Arc-Dark"
xfconf-query -c xfwm4 -p /general/theme -s "Arc-Dark"

echo "[*] Setting XFCE panel color and transparency..."
xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba -s "0.02 0.02 0.02 0.6"


echo "[*] Cloning official Alacritty themes..."
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme.git ~/.config/alacritty/themes

echo "[*] Copying Aura theme..."
cp ~/.config/alacritty/themes/themes/aura.toml ~/.config/alacritty/themes/aura.toml

echo "[*] Creating Alacritty config..."
mkdir -p ~/.config/alacritty
cat > ~/.config/alacritty/alacritty.toml <<EOL
[general]
import = ["~/.config/alacritty/themes/aura.toml"]

[terminal]
shell = { program = "/usr/bin/tmux", args = ["new-session"] }
EOL

echo "[*] Creating basic tmux config..."
mkdir -p ~/.config/tmux
cat > ~/.config/tmux/tmux.conf <<EOL
# Enable mouse scrolling
set -g mouse on
# Unlimited scrollback
set -g history-limit 10000
EOL

echo "[*] Setting up bash prompt..."
if ! grep -Fxq 'export PS1="\w\[\e[91;1m\] $ \[\e[0m\]"' ~/.bashrc; then
    echo 'export PS1="\w\[\e[91;1m\] $ \[\e[0m\]"' >> ~/.bashrc
fi

echo "[*] Setup complete! Open Alacritty to start tmux with Aura theme."
