# Terminal Setup

Cross-platform terminal configuration and tools setup for macOS and Linux.

## Contents

- `ghostty/`: Ghostty terminal emulator configuration (entire directory symlinked to `~/.config/ghostty/`)
  - `config`: Ghostty configuration with keybindings and settings
  - `colours/`: Color schemes (eva01, eva02)
- `iterm2/`: iTerm2 configuration (macOS)
  - `colours/`: Color schemes (`*.itermcolors`)
  - `Custom.json`: Custom iTerm2 profile
- `starship.toml`: Starship prompt configuration

## Installed Tools

Running `./setup` installs and configures the following:

- **uv**: Fast Python package installer and virtual environment manager
- **fnm**: Fast Node.js version manager (auto-switches per project)
- **pnpm**: Fast, disk-efficient package manager
- **starship**: Cross-shell prompt with Git integration and customization
- **zsh-completions**: Additional completion definitions for ZSH
- **Ghostty**: Modern, GPU-accelerated terminal emulator

PATH configuration for these tools is handled in `shell/.zsh/base.zsh`.

## Ghostty Terminal

[Ghostty](https://ghostty.org) is a modern, GPU-accelerated terminal emulator. The configuration includes:

- **Font**: FiraCode Nerd Font Mono @ 12pt
- **Color scheme**: Eva01-inspired dark theme with purple/green accents (switchable to eva02)
- **Cursor**: Non-blinking block cursor
- **Scrollback**: 1000 lines

### Keybindings

| Keybinding | Action |
|------------|--------|
| `Cmd+Shift+[` / `]` | Previous/next tab |
| `Alt+Left` / `Right` | Word movement |
| `Cmd+Left` / `Right` | Line start/end |
| `Alt+Backspace` | Delete word backward |
| `Cmd+Backspace` | Delete to line start |
| `Ctrl+Backspace` | Delete word backward (alternative) |
| `Shift+Enter` | Newline without executing (for Claude Code, etc.) |

## iTerm2 (macOS Only)

### Importing Color Schemes

1. Open iTerm2
2. Go to Preferences > Profiles > Colors
3. Click Color Presets > Import
4. Select a color scheme from `iterm2/colours/` (e.g., `eva01.itermcolors`)

### Importing Custom Profile

1. Open iTerm2
2. Go to Preferences > Profiles
3. Click Other Actions > Import JSON Profiles
4. Select `iterm2/Custom.json`

## Starship Configuration

The custom Starship prompt is configured in `starship.toml`. It includes:
- Git status and branch information
- Current directory
- Docker container status
- Language version indicators (Python, Node.js, etc.)

The configuration is symlinked to `~/.config/starship.toml`, which is the default location Starship looks for.
