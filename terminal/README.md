# Terminal Setup

This directory contains terminal configuration and tools setup.

## Contents

- `colors/`: Terminal color schemes
  - `*.itermcolors`: Color schemes for iTerm2
- `Custom.terminal`: Profile for Terminal.app
- `starship.toml`: Starship prompt configuration

## Installed Tools

Running `./setup` installs the following tools via Homebrew:

- **uv**: Fast Python package installer and virtual environment manager
- **fnm**: Fast Node.js version manager with automatic version switching
- **starship**: Cross-shell prompt with Git integration and customization
- **zsh-completions**: Additional completion definitions for ZSH

All tools are installed via Homebrew for consistency and security.

## Setup

Running `./setup` will:
1. Verify macOS environment
2. Install all required tools via Homebrew (if not already installed)
3. Provide status feedback for each installation

## Terminal Color Schemes (Optional)

After setup, you can optionally install custom color schemes:

**Terminal.app (macOS default):**
1. Open Terminal app
2. Go to Terminal → Settings → Profiles
3. Click Import
4. Select `Custom.terminal` from this directory

**iTerm2:**
1. Open iTerm2
2. Go to Preferences → Profiles → Colors
3. Click Color Presets → Import
4. Select a color scheme from the `colors/` directory (e.g., `eva01.itermcolors`)

## Starship Configuration

The custom Starship prompt is configured in `starship.toml`. It includes:
- Git status and branch information
- Current directory
- Docker container status
- Language version indicators (Python, Node.js, etc.)

The configuration is automatically loaded via the `STARSHIP_CONFIG` environment variable set in `.zshrc`.
