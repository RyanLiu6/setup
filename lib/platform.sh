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

# Install a package using the appropriate package manager
# Usage: install_package <macos_pkg> [linux_pkg]
# If linux_pkg is not provided, macos_pkg is used for both
install_package() {
    local macos_pkg="$1"
    local linux_pkg="${2:-$1}"
    local os=$(detect_os)

    case "$os" in
        macos)
            if ! brew list "$macos_pkg" &> /dev/null; then
                brew install "$macos_pkg"
                return 0
            fi
            return 1  # Already installed
            ;;
        linux)
            if ! dpkg -l "$linux_pkg" 2>/dev/null | grep -q "^ii"; then
                sudo apt-get update -qq
                sudo apt-get install -y "$linux_pkg"
                return 0
            fi
            return 1
            ;;
        *)
            echo "⚠️  Unsupported operating system"
            return 2
            ;;
    esac
}

# Check if a package is installed
# Usage: is_package_installed <macos_pkg> [linux_pkg]
is_package_installed() {
    local macos_pkg="$1"
    local linux_pkg="${2:-$1}"
    local os=$(detect_os)

    case "$os" in
        macos)
            brew list "$macos_pkg" &> /dev/null
            ;;
        linux)
            dpkg -l "$linux_pkg" 2>/dev/null | grep -q "^ii"
            ;;
        *)
            return 1
            ;;
    esac
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
            install_package "zsh" "zsh"
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
        # Handle both Intel and Apple Silicon paths
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        echo "✓ Homebrew installed successfully"
    else
        echo "✓ Homebrew already installed"
        if [[ -f /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -f /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
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
