# Direnv Configuration

This directory contains direnv configuration for automatic Python environment activation:

- `direnvrc`: Global direnv configuration with layouts for:
  - `layout_uv`: Python environments using uv (recommended)
  - `layout_venv`: Python environments using venv
  - `layout_poetry`: Python environments using Poetry
- `.envrc.uv.example`: Example `.envrc` file for uv-based projects

## Setup

Running `./setup` will:
1. Install direnv via Homebrew (if not already installed)
2. Create the direnv config directory (`~/.config/direnv`)
3. Symlink the direnv configuration:
   ```
   ~/.config/direnv/direnvrc → ~/dev/home/direnv/direnvrc
   ```

Changes to `direnvrc` in this repo are immediately reflected.

## Usage

### Starting a New Python Project

1. Create your project directory:
   ```bash
   mkdir myproject && cd myproject
   ```

2. Copy the example template:
   ```bash
   cp ~/dev/home/direnv/.envrc.uv.example .envrc
   ```

3. Allow direnv to activate:
   ```bash
   direnv allow
   ```

4. The virtual environment will be automatically created and activated!

### Manual Setup

Alternatively, create `.envrc` manually in your project directory:

```bash
# For uv (recommended)
echo "layout uv" > .envrc

# For venv
echo "layout venv" > .envrc

# For Poetry
echo "layout poetry" > .envrc
```

Then run `direnv allow` to activate.

### How It Works

When you `cd` into a directory with an `.envrc` file:
- direnv automatically creates a virtual environment (if it doesn't exist)
- The environment is activated automatically
- When you leave the directory, the environment is deactivated

For `layout uv`, it will also automatically install dependencies from your `pyproject.toml` if present.
