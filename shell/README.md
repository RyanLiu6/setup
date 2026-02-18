# Shell Configuration

Cross-platform ZSH shell configuration for macOS and Linux.

## Architecture

```
~/.zshrc                          # Loader file (tools add lines here)
  └── sources ~/dev/dotfiles/shell/.zshrc
        └── sources .zsh/*.zsh    # Modular configs
```

**Key benefit:** Tools can add lines to `~/.zshrc` without breaking your setup. Your customizations live in `~/dev/dotfiles/shell/` and are always sourced.

## Directory Structure

- `.zprofile`: Environment setup loaded at login (Homebrew init on macOS)
- `.zshrc`: Main shell configuration (sourced by ~/.zshrc)
- `.zshrc.loader`: Template for ~/.zshrc loader (includes Ghostty shell integration)
- `.zsh/`: Directory containing modular shell configurations
  - `base.zsh`: Core shell settings, tool PATH setup (uv, pnpm, fnm), and performance optimizations
  - `aliases.zsh`: Command aliases and helper functions (platform-aware)
  - `shellperf.zsh`: Shell performance profiling utilities
  - `work.zsh`: Work-specific configuration (customize as needed)

## Features

### Performance Optimizations
- Lazy loading for fnm (Node.js version manager)
- Completion caching (Homebrew completions on macOS)
- Command evaluation caching
- Optimized completion initialization (cross-platform)
- Total startup time captured automatically

### Built-in Commands

**Shell Management:**
- `reload` - Restart your terminal session (`exec zsh`)
- `shellperf` - Measure shell startup time with detailed breakdown

> **Note:** The `reload` alias uses `exec zsh` to replace the shell process entirely. Ghostty shell integration is manually sourced in `.zshrc.loader` to ensure it reinitializes after reload.

**Docker:**
- `dps` - Enhanced docker ps with formatted output

### Shell Performance Profiling

The `shellperf` command provides detailed timing analysis of shell startup, showing per-section load times and total startup time (including any tool-added lines in `~/.zshrc`).

### Configuration

Running `./setup` symlinks `.zprofile` to `~/.zprofile` and creates/updates `~/.zshrc` to source the dotfiles config (preserving any existing tool additions).

To change your default shell to zsh:
```bash
chsh -s $(which zsh)
```

### Customization

Edit files directly in `~/dev/dotfiles/shell/`:
- Add aliases in `.zsh/aliases.zsh`
- Add work configs in `.zsh/work.zsh`
- Create new `.zsh/*.zsh` files (auto-sourced)

Changes take effect immediately with `reload`.
