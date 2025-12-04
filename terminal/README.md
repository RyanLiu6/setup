# Terminal Setup

Cross-platform terminal configuration and tools setup for macOS and Linux.

## Contents

- `colors/`: Terminal color schemes (macOS)
  - `*.itermcolors`: Color schemes for iTerm2
- `Custom.terminal`: Profile for Terminal.app (macOS)
- `starship.toml`: Starship prompt configuration

## Installed Tools

Running `./setup` installs the following tools:

- **uv**: Fast Python package installer and virtual environment manager
- **fnm**: Fast Node.js version manager (auto-switches per project)
- **pnpm**: Fast, disk-efficient package manager
- **starship**: Cross-shell prompt with Git integration and customization
- **zsh-completions**: Additional completion definitions for ZSH

PATH configuration for these tools is handled in `shell/.zsh/base.zsh`.

### Installation Methods

| Tool | macOS | Linux |
|------|-------|-------|
| uv | Official installer | Official installer |
| fnm | Homebrew | Official installer |
| starship | Homebrew | Official installer |
| zsh-completions | Homebrew | System package manager |

## Setup

Running `./setup` will:
1. Detect your platform (macOS or Linux)
2. Install all required tools using the appropriate method
3. Provide status feedback for each installation

## Terminal Color Schemes (macOS Only)

After setup, you can optionally install custom color schemes:

**Terminal.app:**
1. Open Terminal app
2. Go to Terminal → Settings → Profiles
3. Click Import
4. Select `Custom.terminal` from this directory

**iTerm2:**
1. Open iTerm2
2. Go to Preferences → Profiles → Colors
3. Click Color Presets → Import
4. Select a color scheme from the `colors/` directory (e.g., `eva01.itermcolors`)

## Starship Configuration

The custom Starship prompt is configured in `starship.toml`. It includes:
- Git status and branch information
- Current directory
- Docker container status
- Language version indicators (Python, Node.js, etc.)

The configuration is automatically loaded via the `STARSHIP_CONFIG` environment variable set in `.zshrc`.

## Node.js with pnpm

fnm automatically installs and switches Node versions per-project when a `.node-version` or `.nvmrc` file is present.

```bash
# Install Node for a project
cd my-project
echo "20" > .node-version  # fnm will auto-install on cd

# Or manually install a version
fnm install 20
fnm use 20
```
