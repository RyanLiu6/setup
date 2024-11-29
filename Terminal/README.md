 # Terminal Setup

This directory contains terminal configuration and tools setup.

- `colors/`: Terminal color schemes
  - `*.itermcolors`: Color schemes for iTerm2
- `Custom.terminal`: Profile for Terminal.app

Specifically, the following dependencies are installed:
  - uv: Fast Python package installer
  - fnm: Fast Node version manager
  - starship: Shell prompt customization
  - zsh-completions: Additional ZSH completions

## Setup
Running `./setup` will:
1. Install the dependencies

Next, install the chosen profile:
* Terminal.app (Default) - Terminal -> Settings -> Profiles -> Import -> `Custom.terminal`
* iTerm2 - Preferences -> Profiles -> Colors -> Color Presets -> Import -> `eva01.itermcolors`
