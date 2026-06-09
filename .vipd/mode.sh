# VIPD Mode Utility
# Usage: source .vipd/mode.sh [read|write|set]
#   read  - prints current mode (standard|claude-code)
#   write - writes mode to .vipd/config.yml (reads from stdin)
#   set   - sets mode to given argument

VIPD_CONFIG=".vipd/config.yml"

mode_read() {
  if [ ! -f "$VIPD_CONFIG" ]; then
    echo "standard"
    return
  fi
  local mode
  mode=$(grep -E '^mode:' "$VIPD_CONFIG" | sed 's/^mode:[[:space:]]*//')
  echo "${mode:-standard}"
}

mode_write() {
  local new_mode="$1"
  if [ ! -f "$VIPD_CONFIG" ]; then
    echo "mode: $new_mode" > "$VIPD_CONFIG"
    return
  fi
  if grep -qE '^mode:' "$VIPD_CONFIG"; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "s/^mode:.*/mode: $new_mode/" "$VIPD_CONFIG"
    else
      sed -i "s/^mode:.*/mode: $new_mode/" "$VIPD_CONFIG"
    fi
  else
    echo "mode: $new_mode" >> "$VIPD_CONFIG"
  fi
}

case "${1:-read}" in
  read)  mode_read ;;
  write) mode_write "$(cat)" ;;
  set)   mode_write "$2" ;;
  *)     echo "Usage: $0 [read|write|set <mode>]" >&2; exit 1 ;;
esac
