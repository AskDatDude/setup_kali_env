#!/bin/bash
# Kali Linux Custom Environment Setup
# Alacritty + tmux + Arc-Dark + Roboto Thin + bash prompt
# Minimal Alacritty config using official alacritty-theme
# Fully automated, installs missing dependencies

set -e

echo "[*] Updating system..."
sudo apt update && sudo apt full-upgrade -y

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
# Set Alacritty as default terminal in XFCE utilities
xfconf-query -c xfce4-settings-manager -p /utilities/terminal-emulator -s "alacritty" --create --type string

echo "[*] Applying Arc-Dark theme..."
xfconf-query -c xsettings -p /Net/ThemeName -s "Arc-Dark"
xfconf-query -c xfwm4 -p /general/theme -s "Arc-Dark"

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

echo "[*] Setting up bash prompt..."
if ! grep -Fxq 'export PS1="\w\[\e[91;1m\] $ \[\e[0m\]"' ~/.bashrc; then
    # Add robust bash prompt with fallback
    cat >> ~/.bashrc << 'EOF'
# Custom bash prompt - added by setup_kali_env.sh
# Check if terminal supports colors
if [[ $TERM == *"color"* ]] || [[ $TERM == "xterm"* ]] || [[ $TERM == "alacritty" ]] || [[ $TERM == "tmux"* ]]; then
    export PS1="\w\[\e[91;1m\] $ \[\e[0m\]"
else
    export PS1="\w $ "
fi
EOF
    echo "[*] Bash prompt added to ~/.bashrc - will take effect in new shells"
else
    echo "[*] Bash prompt already configured"
fi

echo "[*] Debugging terminal environment..."
echo "    Current TERM: $TERM"
echo "    Current SHELL: $SHELL"
echo "    Bash version: $BASH_VERSION"
if command -v tput &> /dev/null; then
    echo "    Terminal colors supported: $(tput colors 2>/dev/null || echo 'unknown')"
else
    echo "    tput command not available"
fi

echo "[*] Adding error handling to bashrc..."
if ! grep -q "Error handling for missing commands" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'

# Error handling for missing commands - added by setup_kali_env.sh
# Prevent errors when sourcing bashrc
set +e
EOF
    echo "[*] Error handling added to ~/.bashrc"
else
    echo "[*] Error handling already configured"
fi

echo "[*] Setup complete! Open Alacritty to start tmux with Aura theme."
echo "[*] To revert all changes, run the restore_kali_env.sh script."