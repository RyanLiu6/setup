# Git Configuration
This directory contains global Git configuration:

- `.gitignore_global`: Global git ignore patterns
  - Ignores common system files (.DS_Store)
  - Ignores editor files (.vscode/)
  - Ignores direnv environment files (.envrc)

## Setup
Running `./setup` will:
1. Copy the global gitignore to your home directory
2. Configure git to use this global gitignore
