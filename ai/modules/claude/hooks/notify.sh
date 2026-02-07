#!/bin/bash
# Claude Code notification hook using terminal-notifier.
#
# Usage (from Claude Code hooks config):
#   notify.sh <event>
#
# Events:
#   idle_prompt - Claude is waiting for user input
#   stop        - Claude has stopped execution

set -euo pipefail

EVENT="${1:-}"
TITLE="Claude Code"

case "$EVENT" in
    idle_prompt)
        terminal-notifier \
            -title "$TITLE" \
            -message "Waiting for your input" \
            -sound Glass \
            -group "claude-code"
        ;;
    stop)
        terminal-notifier \
            -title "$TITLE" \
            -message "Execution stopped" \
            -sound Basso \
            -group "claude-code"
        ;;
    *)
        terminal-notifier \
            -title "$TITLE" \
            -message "$EVENT" \
            -sound Default \
            -group "claude-code"
        ;;
esac
