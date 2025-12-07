# Git Configuration

This directory contains global Git configuration:

- `.gitignore_global`: Global git ignore patterns for common files
- `.gitconfig.shared`: Shared git settings for all machines

## Architecture

This setup separates git configuration into two layers:

1. **Shared Configuration** (`.gitconfig.shared`): Version-controlled settings that should be consistent across all machines
2. **Local Configuration** (`~/.gitconfig`): Machine-specific settings like user info, credentials, and OS-specific helpers

Your local `~/.gitconfig` includes the shared config using:
```ini
[include]
    path = ~/dev/setup/git/.gitconfig.shared
```

## Features

### Global Gitignore

The global gitignore automatically excludes:
- System files (`.DS_Store`, `Thumbs.db`)
- Editor and IDE directories (`.vscode/`, `.idea/`)
- Environment files (`.envrc`, `.env`)
- Python artifacts (`__pycache__/`, `*.pyc`)
- Node.js files (`node_modules/`)

### Shared Git Settings

The `.gitconfig.shared` file includes:

**Workflow preferences:**
- **Auto-setup remote**: Automatically sets up remote tracking when pushing new branches (`push.autoSetupRemote`)
- **Auto-prune**: Removes stale remote-tracking branches on fetch/pull (`fetch.prune`)
- **SSH for GitHub**: Rewrites HTTPS GitHub URLs to SSH

**Display preferences:**
- Whitespace handling rules
- Mnemonic prefixes in diffs
- Merge statistics

**Aliases:**
- `git com`: Checkout main or master branch
- `git prune-branches`: Delete local branches whose upstream has been removed

### Machine-Specific Settings

Keep these in your local `~/.gitconfig` (not version controlled):
- `[user]` name and email
- `[credential]` helpers (OS-specific)
- `[http]` settings that may vary by network
- `[safe]` directory entries

## Setup

Running `./setup` will:
1. Verify Git is installed
2. Symlink the global gitignore:
   ```
   ~/.gitignore_global → ~/dev/setup/git/.gitignore_global
   ```
3. Configure Git to include the shared configuration:
   ```
   git config --global include.path "~/dev/setup/git/.gitconfig.shared"
   ```

Changes to `.gitignore_global` or `.gitconfig.shared` in this repo are immediately reflected across all Git operations.

## Technical Notes

### Reading Git Config Values

When verifying git configuration, note the difference between `git config --global` and `git config`:

- `git config --global <key>` - Reads **only** from `~/.gitconfig` (does not include files)
- `git config <key>` - Reads from **all sources** including `~/.gitconfig`, included files like `.gitconfig.shared`, local repo config, and system config

**For testing/verification:**
```bash
# Check include.path is set in global config
git config --global include.path  # Returns: ~/dev/setup/git/.gitconfig.shared

# Check settings from shared config (must omit --global to read included files)
git config push.autosetupremote   # Returns: true (from .gitconfig.shared)
git config alias.prune-branches   # Returns: <alias definition>
```

This is why CI tests use `git config` without `--global` when verifying settings from `.gitconfig.shared` - it tests what users actually experience when running git commands.
