# Development Environment Setup

A modular development environment configuration focusing on Python, Node.js, and shell productivity.

## Overview

Cross-platform configuration for macOS and Linux:

- Shell (ZSH) configuration with performance optimizations
- Python environment management (uv, venv, poetry)
- Node.js version management (fnm + pnpm)
- Development tools (direnv, starship)
- Terminal customization (Ghostty, iTerm2)

## Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dev/dotfiles
   ```

2. Run the setup script:
   ```bash
   cd ~/dev/dotfiles
   ./scripts/setup
   ```

3. Restart your terminal:
   ```bash
   source ~/.zshrc
   ```

**Note:** Later on, you can use `reload` to restart your terminal.

## Resetting a Broken Setup

If something is broken or you want a fresh start, run `./scripts/reset`. This removes and recreates all config symlinks, reinstalls missing tools, and resets shell configuration (backing up existing `.zshrc`).

## Custom Installation Path

Scripts auto-detect the repo path, but you can override it:

```bash
export REPO_DIR=/path/to/your/dotfiles
cd $REPO_DIR
./scripts/setup
```

## Components

- **[Terminal](terminal/README.md)**: Ghostty/iTerm2 config, starship prompt, uv, fnm + pnpm
- **[Shell](shell/README.md)**: Modular ZSH configuration with lazy loading and startup profiling
- **[Python](direnv/README.md)**: Environment management (uv, venv, poetry) with direnv auto-activation and `pyinit` scaffolding
- **[Git](git/README.md)**: Global gitignore, shared settings, machine-specific overrides

## Supported Platforms

- **macOS** (Intel and Apple Silicon) - requires Homebrew and Git
- **Linux** (Debian/Ubuntu) - requires Git and sudo access

Zsh and Homebrew are installed automatically if missing.

## Customization

Each component can be customized by editing its configuration:

- Shell: `shell/.zsh/*.zsh`
- Terminal: `terminal/starship.toml`, `terminal/ghostty/` (entire directory symlinked)
- Python: `direnv/direnvrc`
- Git: `git/.gitignore_global`

All configuration files are symlinked, so changes are immediately reflected without re-running setup.

## Useful Commands

- `reload` - Restart your terminal session
- `shellperf` - Measure shell startup performance
- `dps` - Enhanced docker ps with formatted output

## Testing

Automated tests run via GitHub Actions on every push and PR, verifying setup scripts, config files, tool installation, and idempotency on both macOS and Ubuntu.
