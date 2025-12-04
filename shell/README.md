# Shell Configuration

Cross-platform ZSH shell configuration for macOS and Linux.

## Architecture

```
~/.zshrc                          # Loader file (tools add lines here)
  └── sources ~/dev/setup/shell/.zshrc
        └── sources .zsh/*.zsh    # Modular configs
```

**Key benefit:** Tools can add lines to `~/.zshrc` without breaking your setup. Your customizations live in `~/dev/setup/shell/` and are always sourced.

## Directory Structure

- `.zprofile`: Environment setup loaded at login (Homebrew init on macOS)
- `.zshrc`: Main shell configuration (sourced by ~/.zshrc)
- `.zshrc.loader`: Template for ~/.zshrc loader
- `.zsh/`: Directory containing modular shell configurations
  - `base.zsh`: Core shell settings, performance optimizations, and utility functions
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
- `reload` - Restart your terminal session
- `shellperf` - Measure shell startup time with detailed breakdown

**Docker:**
- `dps` - Enhanced docker ps with formatted output

### Shell Performance Profiling

The `shellperf` command provides detailed timing analysis of shell startup:

```bash
shellperf
```

Output example:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Shell Startup Performance Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[base] 45ms
  └─ Start base configuration: 2ms
  └─ Loaded base configs: 30ms
  └─ Loading Starship prompt: 8ms
  └─ Loaded Starship prompt: 5ms

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Config load time: 45ms
Total startup time: 52ms (captured at first prompt)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

The "Total startup time" includes everything in `~/.zshrc`, including any tool-added lines.

**Adding custom timing tags:**

In any `.zsh` file, use `_shellperf_tag` to mark timing points:

```bash
_shellperf_tag "tagname" "Description of what you're measuring"
# ... code to measure ...
_shellperf_tag "tagname" "After the operation"
```

### Configuration

Running `./setup` will:
1. Copy `.zprofile` to `~/.zprofile`
2. Create/update `~/.zshrc` to source our config (preserving any existing tool additions)
3. Prompt you to set ZSH as your default shell (if not already)

To change your default shell to zsh:
```bash
chsh -s $(which zsh)
```

### Customization

Edit files directly in `~/dev/setup/shell/`:
- Add aliases in `.zsh/aliases.zsh`
- Add work configs in `.zsh/work.zsh`
- Create new `.zsh/*.zsh` files (auto-sourced)

Changes take effect immediately with `reload`.
