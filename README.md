# Kali Linux Visual Environment Setup

This repository contains scripts to quickly transform your Kali Linux desktop into a modern, visually enhanced environment with Alacritty terminal, tmux, Arc-Dark theme, and custom bash prompt.

## ⚠️ Important Notice

**These scripts perform a full system update (`apt update && apt full-upgrade`)** which can take significant time and may modify core system packages. Use with caution on production systems.

## What the Setup Script Does

### 📦 System Updates & Package Installation
- **Full system update**: `apt update && apt full-upgrade -y`
- **Installs packages**:
  - `alacritty` - Modern GPU-accelerated terminal emulator
  - `tmux` - Terminal multiplexer for session management
  - `fonts-roboto` - Google's Roboto font family
  - `git` - Version control system (for theme repository)
  - `xfce4` - XFCE desktop environment components
  - `xfce4-terminal` - Default XFCE terminal (kept as fallback)
  - `arc-theme` - Modern flat theme with transparency support

### 🎨 Visual Configuration
- **Terminal Setup**:
  - Sets Alacritty as default terminal emulator (system-wide and XFCE)
  - Configures Alacritty with Aura dark theme
  - Auto-launches tmux sessions in Alacritty
- **Desktop Theme**:
  - Applies Arc-Dark theme to XFCE desktop and window manager
  - Replaces default Kali-Dark theme
- **Shell Customization**:
  - Adds custom red-accented bash prompt: `current_directory $ `
  - Maintains existing `.bashrc` content

### 🔧 Configuration Files Created
- `~/.config/alacritty/alacritty.toml` - Alacritty terminal configuration
- `~/.config/alacritty/themes/` - Official Alacritty themes repository
- `~/.config/tmux/tmux.conf` - Tmux configuration with mouse support
- Modified `~/.bashrc` - Adds custom PS1 prompt

## What the Restore Script Does

### 🗑️ Complete Removal
- **Removes installed packages**: `alacritty`, `tmux`, `fonts-roboto`, `arc-theme`
- **Deletes configuration directories**: `~/.config/alacritty`, `~/.config/tmux`
- **Reverts theme**: Restores Kali-Dark theme for desktop and windows
- **Resets terminal**: Restores `xfce4-terminal` as default
- **Cleans bash prompt**: Removes custom PS1 from `.bashrc`
- **System cleanup**: Runs `apt autoremove` to clean unused dependencies

## How to Run

### 🚀 Quick Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/AskDatDude/setup_kali_env.git
   cd setup_kali_env
   ```

2. **Run the setup script**:
   ```bash
   bash setup_kali_env.sh
   ```

4. **Open Alacritty** to see the new environment in action

### 🔄 Restore Original Environment

To completely revert all changes:
```bash
./restore_kali_env.sh
```

## 📋 Requirements

- **Kali Linux** with XFCE desktop environment
- **Internet connection** for package downloads and theme repository
- **Sudo privileges** for package installation and system configuration
- **Approximately 100-200MB** disk space for packages and themes

## 📝 Important Notes

### ⏰ Performance Considerations
- **First run takes 10-30 minutes** due to full system upgrade
- **Internet bandwidth usage**: 100-500MB depending on system state
- **Subsequent runs are faster** (only missing packages installed)

### 🔒 System Impact
- **Modifies system alternatives** for default terminal
- **Changes XFCE appearance settings** (theme, terminal preferences)
- **Updates package database** and upgrades all system packages
- **Safe to run multiple times** - script checks existing configurations

### 🎯 Visual Results
- **Modern terminal**: GPU-accelerated Alacritty with dark theme
- **Enhanced workflow**: Persistent tmux sessions with mouse support
- **Consistent theming**: Arc-Dark theme across desktop environment
- **Improved prompt**: Directory-aware bash prompt with color coding

### 🛠️ Troubleshooting
- **Theme not applied**: Log out and back in to refresh XFCE settings
- **Prompt not visible**: Open a new terminal session or run `source ~/.bashrc`
- **Permission errors**: Ensure you have sudo privileges
- **Package conflicts**: Run `sudo apt update` before setup if issues occur

### 🔧 Customization
- **Alacritty themes**: Browse `~/.config/alacritty/themes/themes/` for alternatives
- **Tmux configuration**: Edit `~/.config/tmux/tmux.conf` for custom settings
- **Bash prompt**: Modify the PS1 line in `~/.bashrc` for different colors/format

## 📄 File Structure

```
setup_kali_env/
├── setup_kali_env.sh     # Main setup script
├── restore_kali_env.sh   # Complete restoration script
└── README.md            # This documentation
```

---

**Author**: AskDatDude  
**License**: Open source - modify and distribute freely  
**Last Updated**: September 2025