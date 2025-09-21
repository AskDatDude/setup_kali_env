#!/bin/bash
# Kali Linux Custom Environment Setup
# Alacritty + tmux + Arc-Dark + Roboto Thin + bash prompt
# Minimal Alacritty config using official alacritty-theme
# Fully automated, installs missing dependencies

set -e

echo "[*] Updating system..."
sudo apt update -y

echo "[*] Installing packages..."
sudo apt install -y alacritty tmux fonts-roboto git xfce4 xfce4-terminal arc-theme

echo "[*] Verifying Arc theme installation..."
if ! dpkg -l | grep -q "arc-theme"; then
    echo "[!] Arc theme installation failed. Retrying..."
    sudo apt install -y arc-theme
fi

echo "[*] Setting Alacritty as default terminal..."
# Add Alacritty to alternatives and select automatically
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50
sudo update-alternatives --set x-terminal-emulator /usr/bin/alacritty

echo "[*] Setting Alacritty as default in XFCE applications..."
# Set Alacritty as default terminal in XFCE utilities tab
xfconf-query -c xfce4-mime-settings -p /utilities/terminal-emulator -s "alacritty.desktop" --create --type string
xfconf-query -c xfce4-settings-manager -p /utilities/terminal-emulator -s "alacritty" --create --type string

echo "[*] Updating panel launcher..."
# Find and replace qterminal launcher in XFCE panel
xfconf-query -c xfce4-panel -l | grep "items" | while read prop; do
    items=$(xfconf-query -c xfce4-panel -p "$prop" 2>/dev/null || echo "")
    if echo "$items" | grep -q "qterminal"; then
        echo "[*] Found qterminal in $prop, replacing with alacritty"
        new_items=$(echo "$items" | sed 's|qterminal.desktop|alacritty.desktop|g')
        xfconf-query -c xfce4-panel -p "$prop" -s "$new_items" --create --type array --type string 2>/dev/null || true
    fi
done

echo "[*] Applying Arc-Dark theme..."
xfconf-query -c xsettings -p /Net/ThemeName -s "Arc-Dark"
xfconf-query -c xfwm4 -p /general/theme -s "Arc-Dark"

echo "[*] Setting custom wallpaper..."
# Copy the wallpaper to a permanent location
mkdir -p ~/Pictures/Wallpapers
cp "boliviainteligente-37WxvlfW3to-unsplash.jpg" ~/Pictures/Wallpapers/custom_wallpaper.jpg
echo "[*] Wallpaper copied to ~/Pictures/Wallpapers/"

# Set as desktop background for all monitors and workspaces
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s "$HOME/Pictures/Wallpapers/custom_wallpaper.jpg" --create --type string
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$HOME/Pictures/Wallpapers/custom_wallpaper.jpg" --create --type string 2>/dev/null || true
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/image-style -s 5 --create --type int
xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/image-style -s 5 --create --type int 2>/dev/null || true
echo "[*] Desktop background set to custom wallpaper"

echo "[*] Cloning official Alacritty themes..."
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme.git ~/.config/alacritty/themes

echo "[*] Copying Aura theme..."
cp ~/.config/alacritty/themes/themes/aura.toml ~/.config/alacritty/themes/aura.toml

echo "[*] Creating minimal Alacritty config..."
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

echo "[*] Changing default shell to bash..."
if [[ $SHELL != "/bin/bash" ]]; then
    chsh -s /bin/bash
    echo "[*] Shell changed to bash - will take effect on next login"
else
    echo "[*] Shell is already bash"
fi

echo "[*] Setting up bash prompt..."
if ! grep -Fxq 'export PS1="\w\[\e[91;1m\] $ \[\e[0m\]"' ~/.bashrc; then
    echo 'export PS1="\w\[\e[91;1m\] $ \[\e[0m\]"' >> ~/.bashrc
    echo "[*] Bash prompt added to ~/.bashrc"
else
    echo "[*] Bash prompt already configured"
fi

echo "[*] Sourcing bashrc to apply changes..."
bash -c "source ~/.bashrc" 2>/dev/null || true

echo "[*] Setup complete! Log out and back in or restart to see all changes."
echo "[*] To revert all changes, run the restore_kali_env.sh script."