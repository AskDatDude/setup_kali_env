#!/bin/bash
# Kali Linux Full Environment Cleanup
# Completely removes all changes made by the custom environment setup

set -e

echo "[*] Removing Alacritty configuration and themes..."
rm -rf ~/.config/alacritty
rm -rf ~/.config/alacritty/themes

echo "[*] Removing tmux configuration..."
rm -rf ~/.config/tmux

echo "[*] Removing bash prompt customization..."
sed -i '/export PS1="\\w\\\[\\e\[91;1m\\\] \$ \\\[\\e\[0m\\\]"/d' ~/.bashrc
source ~/.bashrc || true

echo "[*] Resetting XFCE theme to default..."
xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita"
xfconf-query -c xfwm4 -p /general/theme -s "Adwaita"

echo "[*] Resetting XFCE panel color and transparency..."
# Default RGBA: light gray background, fully opaque
xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba -s "0.8 0.8 0.8 1"

echo "[*] Removing installed packages..."
sudo apt remove --purge -y alacritty tmux fonts-roboto git xfce4-terminal
sudo apt autoremove -y

echo "[*] Full cleanup complete! All files and packages from the setup have been removed."
