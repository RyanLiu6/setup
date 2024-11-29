# Direnv Configuration
This directory contains direnv configuration:

- `direnvrc`: Global direnv configuration with layouts for:
  - `layout_uv`: Python environments using uv
  - `layout_venv`: Python environments using venv
  - `layout_poetry`: Python environments using Poetry

## Setup
Running `./setup` will:
1. Create the direnv config directory
2. Copy the direnv configuration
3. Install direnv (on macOS)

## Usage
In any Python project directory, first create `.envrc` with the following:
```bash
layout uv
```

Then run:
```bash
direnv allow
```
