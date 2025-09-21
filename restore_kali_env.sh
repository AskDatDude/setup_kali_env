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
echo "[*] Bash prompt removed - will take effect in new shells"

echo "[*] Restoring default shell..."
# Note: User may need to manually change shell back if desired
echo "[*] Shell change requires manual restoration if needed (chsh -s /bin/zsh)"

echo "[*] Resetting default terminal emulator..."
sudo update-alternatives --auto x-terminal-emulator

echo "[*] Resetting XFCE default terminal..."
# Reset XFCE utilities terminal to default (xfce4-terminal)
xfconf-query -c xfce4-mime-settings -p /utilities/terminal-emulator -s "xfce4-terminal.desktop" --create --type string 2>/dev/null || true
xfconf-query -c xfce4-settings-manager -p /utilities/terminal-emulator -s "xfce4-terminal" --create --type string 2>/dev/null || true

echo "[*] Restoring desktop application shortcuts..."
# Restore any desktop files that were modified to use alacritty back to their original terminals
if [ -d "/usr/share/applications" ]; then
    # Restore system-wide desktop files
    sudo find /usr/share/applications -name "*.desktop" -exec grep -l "alacritty" {} \; 2>/dev/null | while read file; do
        # Check if this file originally had qterminal or xfce4-terminal and restore it
        if [[ "$file" == *"qterminal"* ]]; then
            sudo sed -i 's/alacritty/qterminal/g' "$file" 2>/dev/null || true
        else
            sudo sed -i 's/alacritty/xfce4-terminal/g' "$file" 2>/dev/null || true
        fi
        echo "[*] Restored terminal reference in $file"
    done
fi

# Restore user-specific desktop files
if [ -d "~/.local/share/applications" ]; then
    find ~/.local/share/applications -name "*.desktop" -exec grep -l "alacritty" {} \; 2>/dev/null | while read file; do
        if [[ "$file" == *"qterminal"* ]]; then
            sed -i 's/alacritty/qterminal/g' "$file" 2>/dev/null || true
        else
            sed -i 's/alacritty/xfce4-terminal/g' "$file" 2>/dev/null || true
        fi
        echo "[*] Restored terminal reference in $file"
    done
fi

# Reset XFCE keyboard shortcuts
xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Primary><Alt>t" -s "xfce4-terminal" 2>/dev/null || true
xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom/<Primary><Alt>t" -s "xfce4-terminal" 2>/dev/null || true

echo "[*] Restoring original wallpaper..."
# Remove custom wallpaper
rm -f ~/Pictures/Wallpapers/custom_wallpaper.jpg 2>/dev/null || true
# Reset to default Kali wallpaper
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s "/usr/share/backgrounds/kali/kali-16x9.png" 2>/dev/null || true
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "/usr/share/backgrounds/kali/kali-16x9.png" 2>/dev/null || true

echo "[*] Resetting XFCE theme to default..."
xfconf-query -c xsettings -p /Net/ThemeName -s "Kali-Dark"
xfconf-query -c xfwm4 -p /general/theme -s "Kali-Dark"

echo "[*] Removing installed packages..."
sudo apt remove --purge -y alacritty tmux fonts-roboto arc-theme
sudo apt autoremove -y

echo "[*] Restore complete! All customizations have been removed and settings restored."
