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

Running `./setup` installs the following tools:

- **uv**: Fast Python package installer and virtual environment manager
- **fnm**: Fast Node.js version manager (auto-switches per project)
- **pnpm**: Fast, disk-efficient package manager
- **starship**: Cross-shell prompt with Git integration and customization
- **zsh-completions**: Additional completion definitions for ZSH
- **Ghostty**: Modern, GPU-accelerated terminal emulator

PATH configuration for these tools is handled in `shell/.zsh/base.zsh`.

### Installation Methods

| Tool | macOS | Linux |
|------|-------|-------|
| uv | Official installer | Official installer |
| fnm | Homebrew | Official installer |
| pnpm | Official installer | Official installer |
| starship | Homebrew | Official installer |
| zsh-completions | Homebrew | System package manager |
| Ghostty | Homebrew Cask | Debian repo / AUR |

## Setup

Running `./setup` will:
1. Detect your platform (macOS or Linux)
2. Install all required tools using the appropriate method
3. Symlink Ghostty directory to `~/.config/ghostty/`
4. Symlink Starship config to `~/.config/starship.toml`
5. Provide status feedback for each installation

## Ghostty Terminal

[Ghostty](https://ghostty.org) is a modern, GPU-accelerated terminal emulator. The configuration includes:

- **Font**: FiraCode Nerd Font Mono @ 12pt
- **Color scheme**: Eva01-inspired dark theme with purple/green accents (switchable to eva02)
- **Cursor**: Non-blinking block cursor
- **Scrollback**: 1000 lines

### Configuration Location

The entire Ghostty directory is symlinked from this repo:
```
~/.config/ghostty/ → ~/dev/dotfiles/terminal/ghostty/
```

This ensures relative paths in the config (like `config-file = colours/eva01`) resolve correctly. Changes to the config in this repo are immediately reflected.

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

#### Shift+Enter Compatibility

Ghostty uses a modern keyboard protocol ("fixterms") that sends disambiguated key sequences. However, most applications (including Claude Code) expect legacy escape sequences. By default, Shift+Enter sends `[27;2;13~` which apps don't recognize.

The config explicitly binds Shift+Enter to send `\x1b\r` (ESC + carriage return), matching iTerm2's behavior. This is harmless in regular shells (acts like Enter) and enables proper newline insertion in apps like Claude Code.

See [ghostty-org/ghostty#1850](https://github.com/ghostty-org/ghostty/issues/1850) for details.

### Shell Integration

Ghostty shell integration is manually sourced in the zsh loader (`.zshrc.loader`) to ensure it works after `exec zsh` (the `reload` alias). This enables:
- Proper tab title updates
- No false "running process" warnings when closing tabs
- Working directory tracking

### Linux Installation

On Debian/Ubuntu, Ghostty is installed automatically via the community repository at `debian.griffo.io`.

Other Linux distributions are not officially supported - see [Ghostty docs](https://ghostty.org/docs/install/linux) for manual installation.

## iTerm2 (macOS Only)

### Importing Color Schemes

1. Open iTerm2
2. Go to Preferences → Profiles → Colors
3. Click Color Presets → Import
4. Select a color scheme from `iterm2/colours/` (e.g., `eva01.itermcolors`)

### Importing Custom Profile

1. Open iTerm2
2. Go to Preferences → Profiles
3. Click Other Actions → Import JSON Profiles
4. Select `iterm2/Custom.json`

## Starship Configuration

The custom Starship prompt is configured in `starship.toml`. It includes:
- Git status and branch information
- Current directory
- Docker container status
- Language version indicators (Python, Node.js, etc.)

The configuration is symlinked to `~/.config/starship.toml`, which is the default location Starship looks for.

## Node.js with pnpm

fnm automatically installs and switches Node versions per-project when a `.node-version` or `.nvmrc` file is present.

```bash
# Install Node for a project
cd my-project
echo "20" > .node-version  # fnm will auto-install on cd

# Or manually install a version
fnm install 20
fnm use 20
```
