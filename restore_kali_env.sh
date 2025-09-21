#!/bin/bash
# Kali Linux Environment Restore
# Removes all changes made by setup_kali_env.sh and restores original settings

set -e

echo "[*] Removing Alacritty configuration and themes..."
rm -rf ~/.config/alacritty

echo "[*] Removing tmux configuration..."
rm -rf ~/.config/tmux

echo "[*] Removing bash prompt customization..."
sed -i '/^export PS1="\\w\\\[\\e\[91;1m\\\] \$ \\\[\\e\[0m\\\]"$/d' ~/.bashrc
# Remove error handling block
sed -i '/# Error handling for missing commands - added by setup_kali_env.sh/,/^set +e$/d' ~/.bashrc
echo "[*] Bash prompt and error handling removed - will take effect in new shells"

echo "[*] Resetting default terminal emulator..."
sudo update-alternatives --auto x-terminal-emulator

echo "[*] Resetting XFCE default terminal..."
# Reset XFCE utilities terminal to default (xfce4-terminal)
xfconf-query -c xfce4-settings-manager -p /utilities/terminal-emulator -s "xfce4-terminal" --create --type string

echo "[*] Resetting XFCE theme to default..."
xfconf-query -c xsettings -p /Net/ThemeName -s "Kali-Dark"
xfconf-query -c xfwm4 -p /general/theme -s "Kali-Dark"

echo "[*] Removing installed packages..."
sudo apt remove --purge -y alacritty tmux fonts-roboto arc-theme
sudo apt autoremove -y

echo "[*] Restore complete! All customizations have been removed and settings restored."
