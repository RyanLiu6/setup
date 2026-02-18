# Git Configuration

This directory contains global Git configuration:

- `.gitignore_global`: Global git ignore patterns for common files
- `.gitconfig.shared`: Shared git settings for all machines

## Architecture

Git configuration is split into two layers:

1. **Shared Configuration** (`.gitconfig.shared`): Version-controlled settings consistent across all machines
2. **Local Configuration** (`~/.gitconfig`): Machine-specific settings like user info, credentials, and OS-specific helpers

The local config includes the shared config via `[include] path = ~/dev/dotfiles/git/.gitconfig.shared`.

## Features

### Global Gitignore

Excludes system files, editor/IDE directories, environment files, Python artifacts, and `node_modules/`.

### Shared Git Settings

- **Auto-setup remote**: Automatically sets up remote tracking when pushing new branches
- **Auto-prune**: Removes stale remote-tracking branches on fetch/pull
- **SSH for GitHub**: Rewrites HTTPS GitHub URLs to SSH
- **Aliases**: `git com` (checkout main/master), `git prune-branches` (delete merged local branches)

### Machine-Specific Settings

Keep these in your local `~/.gitconfig` (not version controlled):
- `[user]` name and email
- `[credential]` helpers (OS-specific)
- `[http]` settings that may vary by network
- `[safe]` directory entries

## Setup

Running `./setup` symlinks the global gitignore to `~/.gitignore_global` and configures Git to include `.gitconfig.shared`. Changes to either file are immediately reflected.
