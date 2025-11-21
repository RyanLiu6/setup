# Shell Configuration

This directory contains ZSH shell configuration:
- `.zprofile`: Environment setup loaded at login
- `.zshrc`: Main shell configuration
- `.zsh/`: Directory containing modular shell configurations
  - `base.zsh`: Core shell settings, performance optimizations, and utility functions
  - `aliases.zsh`: Command aliases and helper functions
  - `work.zsh`: Work-specific configuration (customize as needed)

## Features

### Performance Optimizations
- Lazy loading for fnm (Node.js version manager)
- Completion caching
- Command evaluation caching
- Optimized completion initialization

### Built-in Commands

**Shell Management:**
- `reload` - Restart your terminal session
- `shellperf` - Measure shell startup time

**Docker:**
- `dps` - Enhanced docker ps with formatted output

### Configuration

Running `./setup` will:
1. Copy all shell configuration files to `~/.zshrc` and `~/.zprofile`
2. Set ZSH as the default shell (if not already)

> [!NOTE]
> Modules are dynamically sourced in `.zshrc`. You can make edits and run `reload` to see changes immediately.
