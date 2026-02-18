#!/bin/bash
input=$(cat)

# Parse all JSON fields in a single jq call
IFS=$'\t' read -r model cost current_dir context_size input_tokens cache_read <<< \
  "$(echo "$input" | jq -r '[
    (.model.display_name // .model.id // "unknown"),
    (.cost.total_cost_usd // 0),
    (.workspace.current_dir // ""),
    (.context_window.context_window_size // 200000),
    (.context_window.current_usage.input_tokens // 0),
    (.context_window.current_usage.cache_read_input_tokens // 0)
  ] | @tsv')"

# Context percentage from actual token usage
total_tokens=$((input_tokens + cache_read))
if [ "$context_size" -gt 0 ]; then
  percent=$((total_tokens * 100 / context_size))
else
  percent=0
fi

# Shorten directory: last two path components
short_dir="${current_dir/#$HOME/~}"
temp_dir="${short_dir/#\~/}"
IFS='/' read -ra parts <<< "$temp_dir"
if [ "${#parts[@]}" -gt 2 ]; then
  short_dir="${parts[-2]}/${parts[-1]}"
fi

# Git info
if [ -n "$current_dir" ]; then
  branch=$(git -C "$current_dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
  changed=$(git -C "$current_dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
fi

# ANSI colors
W='\033[97m'  # brightWhite  - model
R='\033[91m'  # brightRed    - cost
M='\033[95m'  # brightMagenta - branch
D='\033[2m'   # dim          - separators
N='\033[0m'   # reset
SEP="${D} │ ${N}"

# Eva-01 gradient: purple(118,0,168) → green(0,255,65) → orange(255,106,0)
interpolateEva01() {
  local pos=$1
  local r g b

  if [ "$pos" -lt 50 ]; then
    local t=$((pos * 100 / 50))
    r=$((118 + (0 - 118) * t / 100))
    g=$((0 + (255 - 0) * t / 100))
    b=$((168 + (65 - 168) * t / 100))
  else
    local t=$(((pos - 50) * 100 / 50))
    r=$((0 + (255 - 0) * t / 100))
    g=$((255 + (106 - 255) * t / 100))
    b=$((65 + (0 - 65) * t / 100))
  fi

  printf '\033[38;2;%d;%d;%dm' "$r" "$g" "$b"
}

# Partial block characters (1/8 increments)
partial_blocks=("" "▏" "▎" "▍" "▌" "▋" "▊" "▉" "█")

# Progress bar with sub-block precision
bar_length=10
total_units=$((bar_length * 8))
filled_units=$((percent * total_units / 100))
[ "$filled_units" -gt "$total_units" ] && filled_units=$total_units
[ "$filled_units" -lt 0 ] && filled_units=0

bar=""
for ((i=0; i<bar_length; i++)); do
  block_start=$((i * 8))
  block_end=$(((i + 1) * 8))
  color_pos=$((i * 100 / bar_length))
  color_code=$(interpolateEva01 $color_pos)

  if [ "$filled_units" -ge "$block_end" ]; then
    bar+="${color_code}█"
  elif [ "$filled_units" -le "$block_start" ]; then
    bar+="${D}░"
  else
    partial=$((filled_units - block_start))
    bar+="${color_code}${partial_blocks[$partial]}"
  fi
done
bar+="${N}"

# Single line, no trailing newline
start_color=$(interpolateEva01 0)
end_color=$(interpolateEva01 100)
output=""
output+="${W}${model}${N}"
output+="${SEP}${short_dir}"
[ -n "$branch" ] && output+="${SEP}${M}${branch}${N}"
[ "${changed:-0}" -gt 0 ] && output+="${SEP}±${changed}"
output+="${SEP}${start_color}${N}${bar}${end_color}${N}"
output+=" ${D}${percent}%${N}"
output+="${SEP}${R}\$$(printf '%.2f' "$cost")${N}"

printf '%b' "$output"
