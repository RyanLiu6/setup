# Initialize Homebrew (macOS only)
if [[ -f /opt/homebrew/bin/brew ]]; then
    # macOS Apple Silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
    # macOS Intel
    eval "$(/usr/local/bin/brew shellenv)"
fi
