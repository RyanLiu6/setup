# Shell Configuration

Cross-platform ZSH shell configuration for macOS and Linux.

This directory contains:
- `.zprofile`: Environment setup loaded at login (Homebrew init on macOS)
- `.zshrc`: Main shell configuration
- `.zsh/`: Directory containing modular shell configurations
  - `base.zsh`: Core shell settings, performance optimizations, and utility functions
  - `aliases.zsh`: Command aliases and helper functions (platform-aware)
  - `shellperf.zsh`: Shell performance profiling utilities
  - `work.zsh`: Work-specific configuration (customize as needed)
- `.zshrc.local.example`: Template for local customizations (copy to `~/.zshrc.local`)

## Features

### Performance Optimizations
- Lazy loading for fnm (Node.js version manager)
- Completion caching (Homebrew completions on macOS)
- Command evaluation caching
- Optimized completion initialization (cross-platform)

### Built-in Commands

**Shell Management:**
- `reload` - Restart your terminal session
- `shellperf` - Measure shell startup time with detailed breakdown by tags

**Docker:**
- `dps` - Enhanced docker ps with formatted output

### Shell Performance Profiling

The `shellperf` command provides detailed timing analysis of shell startup with support for custom tags:

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

[work] 120ms
  └─ Loading Instacart profile: 115ms
  └─ Loaded Instacart profile: 5ms

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total startup time: 165ms
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Adding custom timing tags:**

In your `~/.zshrc.local` or other config files, use `_shellperf_tag` to mark timing points:

```bash
_shellperf_tag "tagname" "Description of what you're measuring"
# ... code to measure ...
_shellperf_tag "tagname" "After the operation"
```

Common tags: `base`, `work`, `local`, `machine`, etc.

### Configuration

Running `./setup` will:
1. Copy all shell configuration files to `~/.zshrc` and `~/.zprofile`
2. Prompt you to set ZSH as your default shell (if not already)

To change your default shell to zsh:
```bash
chsh -s $(which zsh)
```

> [!NOTE]
> Modules are dynamically sourced in `.zshrc`. You can make edits and run `reload` to see changes immediately.

### Local Customizations

For work-specific or machine-specific configurations that shouldn't be committed to the repository:

1. Copy the template to your home directory:
   ```bash
   cp shell/.zshrc.local.example ~/.zshrc.local
   ```

2. Edit `~/.zshrc.local` to add your customizations:
   ```bash
   # Example: Source work profile
   _shellperf_tag "work" "Loading work profile"
   if [[ -f ~/.instacart_shell_profile ]]; then
       source ~/.instacart_shell_profile
   fi
   _shellperf_tag "work" "Loaded work profile"
   ```

3. The main `.zshrc` automatically sources `~/.zshrc.local` if it exists
4. This file is ignored by git and won't be committed
