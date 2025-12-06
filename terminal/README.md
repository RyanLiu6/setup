# Terminal Setup

Cross-platform terminal configuration and tools setup for macOS and Linux.

## Contents

- `ghostty/`: Ghostty terminal emulator configuration
  - `config`: Ghostty configuration with Eva01-inspired color scheme
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
3. Symlink Ghostty configuration to `~/.config/ghostty/config`
4. Provide status feedback for each installation

## Ghostty Terminal

[Ghostty](https://ghostty.org) is a modern, GPU-accelerated terminal emulator. The configuration includes:

- **Font**: FiraCode Nerd Font Mono @ 12pt
- **Color scheme**: Eva01-inspired dark theme with purple/green accents
- **Cursor**: Non-blinking block cursor
- **Scrollback**: 1000 lines

### Configuration Location

The config is symlinked from this repo:
```
~/.config/ghostty/config → ~/dev/setup/terminal/ghostty/config
```

Changes to the config in this repo are immediately reflected.

### Linux Installation Notes

- **Debian/Ubuntu**: Uses community repository from `debian.griffo.io`
- **Arch**: Installs from AUR (requires yay or paru)
- **Fedora**: Manual installation required ([see docs](https://ghostty.org/docs/install/linux))

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

The configuration is automatically loaded via the `STARSHIP_CONFIG` environment variable set in `.zshrc`.

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
