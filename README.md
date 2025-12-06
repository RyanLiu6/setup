# Development Environment Setup

A modular development environment configuration focusing on Python, Node.js, and shell productivity.

## Overview

This repository contains cross-platform configuration for macOS and Linux:

- 🐚 Shell (ZSH) configuration with performance optimizations
- 🐍 Python environment management (uv, venv, poetry)
- 📦 Node.js version management (fnm + pnpm)
- 🔧 Development tools (direnv, starship)
- 🎨 Terminal customization (Ghostty, iTerm2)

## Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/setup.git ~/dev/setup
   ```

2. Run the setup script:
   ```bash
   cd ~/dev/setup
   ./setup
   ```

3. Restart your terminal:
   ```bash
   source ~/.zshrc
   ```

**Note:** Later on, you can use `reload` to restart your terminal.

## Resetting a Broken Setup

If something is broken or you want a fresh start, run the reset script:

```bash
cd ~/dev/setup
./reset
```

This will:
1. Remove and recreate all config symlinks
2. Reinstall any missing tools
3. Reset shell configuration (backs up existing `.zshrc`)

The reset script takes a "nuclear" approach - it deletes and recreates everything to ensure a clean state.

## Custom Installation Path

By default, the setup expects to be cloned to `~/dev/setup`. If you prefer a different location:

```bash
export SETUP_DIR=/path/to/your/setup
cd $SETUP_DIR
./setup
```

## Components
### Terminal Setup
- Fast python package management with uv
- Node.js version management with fnm + pnpm
- Custom prompt with starship
- Ghostty terminal emulator with custom color scheme
- iTerm2 color schemes and profiles (macOS)

[Learn more](terminal/README.md)

### Shell Configuration
- Modular ZSH configuration (edit `~/dev/setup/shell/` directly)
- `~/.zshrc` acts as loader—tools can add lines without breaking config
- Lazy loading for better startup time
- Total startup time tracking (including tool-added lines)

[Learn more](shell/README.md)

### Python Development
- Multiple python environment management options:
  - uv (recommended)
  - venv
  - poetry
- Automatic environment activation with direnv
- Project scaffolding with `pyinit`

[Learn more](direnv/README.md)

### Git Configuration
- Global gitignore settings
- Common development files ignored

[Learn more](git/README.md)

## Features
### Performance Optimizations
- Lazy loading of heavy commands
- Completion caching
- Command evaluation caching
- Shell startup profiling

### Development Workflow
- Automatic Python virtual environment activation
- Node.js version switching per project
- Custom terminal prompt with git status
- Docker container status in prompt

## Requirements

### macOS
- Homebrew (installed automatically if missing)
- Git
- Zsh (default on macOS)

### Linux
- Debian/Ubuntu, Fedora/RHEL, or Arch-based distributions
- Git
- Zsh (installed automatically if missing)
- sudo access for package installation

## Customization

Each component can be customized by editing its configuration:

- Shell: `shell/.zsh/*.zsh`
- Terminal: `terminal/starship.toml`, `terminal/ghostty/config`
- Python: `direnv/direnvrc`
- Git: `git/.gitignore_global`

All configuration files are symlinked, so changes are immediately reflected without re-running setup.

## Useful Commands

- `reload` - Restart your terminal session
- `shellperf` - Measure shell startup performance
- `dps` - Enhanced docker ps with formatted output

## Testing

This repository includes automated testing via GitHub Actions. The test workflow:

- Runs on every push and pull request
- Tests on both macOS and Ubuntu runners
- Verifies all setup scripts run without errors
- Validates that all configuration files are created
- Confirms all tools are installed and accessible
- Checks git configuration is correct
- Tests setup idempotency (can be run multiple times)

View test results in the "Actions" tab of your GitHub repository.

## Troubleshooting

### Shell Performance
Use the built-in profiling tool to measure startup time:

```bash
shellperf
```
