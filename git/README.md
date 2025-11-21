# Git Configuration

This directory contains global Git configuration:

- `.gitignore_global`: Global git ignore patterns for common files

## Features

### Global Gitignore

The global gitignore automatically excludes:
- System files (`.DS_Store`, `Thumbs.db`)
- Editor and IDE directories (`.vscode/`, `.idea/`)
- Environment files (`.envrc`, `.env`)
- Python artifacts (`__pycache__/`, `*.pyc`)
- Node.js files (`node_modules/`)

### Git Configuration

The setup also configures:
- **Auto-setup remote**: Automatically sets up remote tracking when pushing new branches
  - No need to use `git push -u origin branch-name`
  - Just run `git push` and Git will set up tracking automatically

## Setup

Running `./setup` will:
1. Verify Git is installed
2. Copy `.gitignore_global` to `~/.gitignore_global`
3. Configure Git to use the global gitignore file
4. Enable `push.autoSetupRemote` for easier branch pushing
