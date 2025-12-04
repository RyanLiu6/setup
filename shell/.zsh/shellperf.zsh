# Shell performance profiling utilities

# Global variables for timing (only initialize if not already set)
if [[ ! -v _shellperf_timings ]]; then
    typeset -gA _shellperf_timings
fi
if [[ ! -v _shellperf_tag_times ]]; then
    typeset -gA _shellperf_tag_times
fi
if [[ ! -v _shellperf_last_time ]]; then
    typeset -g _shellperf_last_time=0
fi
if [[ ! -v _shellperf_enabled ]]; then
    typeset -g _shellperf_enabled=0
fi
if [[ ! -v _shellperf_total_time ]]; then
    typeset -g _shellperf_total_time=0
fi

# One-shot precmd hook to capture total startup time (including tool-added lines in ~/.zshrc)
_shellperf_capture_total() {
    if [[ -v _ZSHRC_START_TIME ]]; then
        _shellperf_total_time=$(( (EPOCHREALTIME - _ZSHRC_START_TIME) * 1000 ))
        unset _ZSHRC_START_TIME
    fi
    # Remove ourselves from precmd_functions (one-shot)
    precmd_functions=(${precmd_functions:#_shellperf_capture_total})
}
precmd_functions+=(_shellperf_capture_total)

# Mark a timing point with a tag
# Usage: _shellperf_tag "tag" "description"
_shellperf_tag() {
    if [[ $_shellperf_enabled -eq 0 ]]; then
        return
    fi

    local tag=$1
    local description=$2
    local current_time=$((EPOCHREALTIME*1000))
    local duration=$((current_time - _shellperf_last_time))

    # Store timing with tag
    local key="${tag}::${description}"
    _shellperf_timings[$key]=$duration

    # Update tag total
    if [[ -v _shellperf_tag_times[$tag] ]]; then
        _shellperf_tag_times[$tag]=$((_shellperf_tag_times[$tag] + duration))
    else
        _shellperf_tag_times[$tag]=$duration
    fi

    _shellperf_last_time=$current_time
}

# Main shellperf function
shellperf() {
    echo "\n🔍 Measuring shell startup performance...\n"

    # Enable profiling
    zmodload zsh/datetime
    _shellperf_enabled=1
    _shellperf_timings=()
    _shellperf_tag_times=()

    local start_time=$((EPOCHREALTIME*1000))
    _shellperf_last_time=$start_time

    # Reload full shell configuration (including ~/.zshrc additions)
    source ~/.zshrc

    local end_time=$((EPOCHREALTIME*1000))
    local config_duration=$((end_time - start_time))

    # Disable profiling
    _shellperf_enabled=0

    # Print results grouped by tag
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Shell Startup Performance Report"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"

    # Get sorted list of tags
    local tags=(${(ko)_shellperf_tag_times})

    for tag in $tags; do
        local tag_total=${_shellperf_tag_times[$tag]}
        echo "[$tag] ${tag_total}ms"

        # Print individual timings for this tag
        for key in ${(k)_shellperf_timings}; do
            if [[ $key == ${tag}::* ]]; then
                local desc=${key#*::}
                local time=${_shellperf_timings[$key]}
                echo "  └─ ${desc}: ${time}ms"
            fi
        done
        echo ""
    done

    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Config load time: ${config_duration}ms"
    if [[ $_shellperf_total_time -gt 0 ]]; then
        printf "Total startup time: %.0fms (captured at first prompt)\n" $_shellperf_total_time
    fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
}
