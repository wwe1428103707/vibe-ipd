#!/usr/bin/env bash
# resolve_language.sh — Resolve effective language via priority chain
# Source this script: source .vipd/resolve_language.sh "$@"
# Sets $VIPD_LANG variable
#
# Priority: CLI --lang > .vipd/config.yml > ~/.vipd/config.yml > en
#
# Usage: source .vipd/resolve_language.sh --lang zh
#        source .vipd/resolve_language.sh  # reads config

VIPD_LANG="en"

# Step 1: Check CLI --lang flag
parse_cli_lang() {
  local args=("$@")
  for i in "${!args[@]}"; do
    if [[ "${args[$i]}" == "--lang" ]] && [[ $i -lt $(($# - 1)) ]]; then
      echo "${args[$((i+1))]}"
      return
    fi
  done
  echo ""
}

CLI_LANG=$(parse_cli_lang "$@")
if [[ -n "$CLI_LANG" ]]; then
  VIPD_LANG="$CLI_LANG"
fi

# Step 2: Check project-level config (only if CLI didn't specify)
if [[ "$VIPD_LANG" == "en" ]] && [[ -z "$CLI_LANG" ]]; then
  PROJECT_CONFIG=".vipd/config.yml"
  if [[ -f "$PROJECT_CONFIG" ]]; then
    CONFIG_LANG=$(grep -E '^language:' "$PROJECT_CONFIG" 2>/dev/null | awk '{print $2}' | tr -d '"')
    if [[ -n "$CONFIG_LANG" ]]; then
      VIPD_LANG="$CONFIG_LANG"
    fi
  fi
fi

# Step 3: Check user-level config (only if no project config lang found)
if [[ "$VIPD_LANG" == "en" ]] && [[ -z "$CLI_LANG" ]]; then
  USER_CONFIG="$HOME/.vipd/config.yml"
  if [[ -f "$USER_CONFIG" ]]; then
    CONFIG_LANG=$(grep -E '^language:' "$USER_CONFIG" 2>/dev/null | awk '{print $2}' | tr -d '"')
    if [[ -n "$CONFIG_LANG" ]]; then
      VIPD_LANG="$CONFIG_LANG"
    fi
  fi
fi

# Step 4: Validate language is supported
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LANG_FILE="$BASE_DIR/lang/$VIPD_LANG.yml"
if [[ ! -f "$LANG_FILE" ]]; then
  echo "Warning: Unsupported language '$VIPD_LANG' (no lang/$VIPD_LANG.yml found). Falling back to English." >&2
  VIPD_LANG="en"
fi

# Step 5: Terminal encoding check for CJK languages
if [[ "$VIPD_LANG" == "zh" || "$VIPD_LANG" == "ja" || "$VIPD_LANG" == "ko" ]]; then
  if [[ "$LANG" != *"UTF-8"* && "$LANG" != *"UTF8"* && "$LC_ALL" != *"UTF-8"* && "$LC_ALL" != *"UTF8"* ]]; then
    echo "Warning: The selected language ($VIPD_LANG) may not render correctly in non-UTF-8 terminals." >&2
    echo "  Consider setting LANG=en_US.UTF-8 or LC_ALL=en_US.UTF-8" >&2
  fi
fi

export VIPD_LANG
