# Development Environment Setup

A modular development environment configuration focusing on Python, Node.js, and shell productivity.

## Overview

This repository contains configuration for:

- 🐚 Shell (ZSH) configuration with performance optimizations
- 🐍 Python environment management (uv, venv, poetry)
- 📦 Node.js version management (fnm)
- 🔧 Development tools (direnv, starship)
- 🎨 Terminal customization

## Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/setup.git ~/dev/setup
   ```

2. Run the setup scripts:
   ```bash
   cd ~/dev/setup
   ./terminal/setup  # Install core dependencies
   ./direnv/setup    # Configure direnv
   ./git/setup       # Configure git
   ./shell/setup     # Configure shell
   ```

3. Restart your terminal
   ```bash
   source ~/.zshrc
   ```

## Components
### Terminal Setup
- Fast python package management with uv
- Node.js version management with fnm
- Custom prompt with starship
- Color schemes for Terminal.app and iTerm2

[Learn more](terminal/README.md)

### Shell Configuration
- Modular ZSH configuration
- Lazy loading for better startup time
- Optimized completions
- Useful aliases and functions

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

- macOS (primary support)
- Homebrew
- Git
- Zsh

## Customization

Each component can be customized by editing its configuration:

- Shell: `shell/.zsh/*.zsh`
- Terminal: `terminal/starship.toml`
- Python: `direnv/direnvrc`
- Git: `git/.gitignore_global`

## Troubleshooting

### Shell Performance
Use the built-in profiling tool:

```bash
zsh_profile
```
