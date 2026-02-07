#!/bin/bash
# Platform detection and package installation helpers

# Detect OS type
detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            echo "linux"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Detect Linux distribution (only Debian-based distros are officially supported)
detect_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu|debian|pop|linuxmint)
                echo "debian"
                ;;
            *)
                # Check ID_LIKE for Debian derivatives
                case "$ID_LIKE" in
                    *debian*|*ubuntu*)
                        echo "debian"
                        ;;
                    *)
                        echo "unknown"
                        ;;
                esac
                ;;
        esac
    else
        echo "unknown"
    fi
}

# Get the path to zsh
get_zsh_path() {
    if command -v zsh &> /dev/null; then
        command -v zsh
    elif [[ -x /bin/zsh ]]; then
        echo "/bin/zsh"
    elif [[ -x /usr/bin/zsh ]]; then
        echo "/usr/bin/zsh"
    else
        echo ""
    fi
}

# Ensure zsh is installed
ensure_zsh() {
    if command -v zsh &> /dev/null; then
        return 0
    fi

    local os=$(detect_os)
    case "$os" in
        macos)
            # zsh is default on macOS, should always be available
            return 0
            ;;
        linux)
            echo "📦 Installing zsh..."
            sudo apt-get update -qq
            sudo apt-get install -y zsh
            ;;
    esac
}

# Setup Homebrew on macOS
setup_homebrew() {
    local os=$(detect_os)
    if [[ "$os" != "macos" ]]; then
        return 0
    fi

    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "✓ Homebrew installed successfully"
    else
        echo "✓ Homebrew already installed"
    fi

    # Ensure brew is in PATH (handles Intel and Apple Silicon)
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

# Ensure a symlink exists and points to the correct target.
# Handles stale symlinks (wrong target), existing files (backs up), and missing targets.
ensure_symlink() {
    local src="$1"
    local target="$2"
    local label="$3"

    if [ -L "$target" ]; then
        local current_target
        current_target=$(readlink "$target")
        if [ "$current_target" = "$src" ]; then
            echo "  ✓ $label already linked"
        else
            echo "  → Updating stale $label symlink..."
            rm "$target"
            ln -s "$src" "$target"
            echo "  ✓ $label relinked (was → $current_target)"
        fi
    elif [ -e "$target" ]; then
        echo "  → Backing up existing $label..."
        mv "$target" "$target.backup"
        ln -s "$src" "$target"
        echo "  ✓ $label linked (backup saved)"
    else
        ln -s "$src" "$target"
        echo "  ✓ $label linked"
    fi
}

# Print detected platform info
print_platform_info() {
    local os=$(detect_os)
    echo "🖥️  Detected OS: $os"
    if [[ "$os" == "linux" ]]; then
        local distro=$(detect_distro)
        echo "🐧 Detected distro family: $distro"
    fi
}
