# Shell Configuration
This directory contains ZSH shell configuration:
- `.zprofile`: Environment setup loaded at login
- `.zshrc`: Main shell configuration
- `.zsh/`: Directory containing modular shell configurations
  - `base.zsh`: Core shell settings and functions
  - `aliases.zsh`: Command aliases

## Setup
Running `./setup` will:
1. Copy all shell configuration files to appropriate locations

> [!NOTE]
> Modules are dynamically sourced in .zshrc. So you can make edits and then run `reload` to see changes.
