#!/usr/bin/env bash
# load_strings.sh — Load language strings and provide t() lookup function
# Source this script AFTER resolve_language.sh: source .vipd/load_strings.sh
#
# Usage:
#   source .vipd/resolve_language.sh
#   source .vipd/load_strings.sh
#   t "init.welcome"          → "Welcome to vipd project initialization!"
#   t "error.network"         → "Network error: unable to reach GitHub."
#   t "nonexistent.key"       → "[MISSING] nonexistent.key"
#
# Variables:
#   VIPD_LANG  — resolved language code (must be set before sourcing)
#   t()        — string lookup function

if [[ -z "$VIPD_LANG" ]]; then
  VIPD_LANG="en"
fi

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# t() — String lookup in YAML language file with English fallback
# Usage: t "section.key" [arg1 arg2 ...]
# Supports {placeholder} substitution: {0}, {1}, ... or {name}
function t() {
  local key="$1"
  shift

  # Determine the lookup file: primary language first, fallback to English
  local primary_file="$BASE_DIR/lang/$VIPD_LANG.yml"
  local fallback_file="$BASE_DIR/lang/en.yml"

  # Try primary language file
  local msg=""
  if [[ -f "$primary_file" ]]; then
    msg=$(_get_yaml_value "$primary_file" "$key")
  fi

  # Fall back to English
  if [[ -z "$msg" && -f "$fallback_file" ]]; then
    msg=$(_get_yaml_value "$fallback_file" "$key")
  fi

  if [[ -z "$msg" ]]; then
    echo "[MISSING] $key"
    return
  fi

  # Substitute positional arguments ({0}, {1}, ...)
  local i=0
  for arg in "$@"; do
    if [[ "$arg" != *=* ]]; then
      msg="${msg//\{$i\}/$arg}"
      i=$((i + 1))
    fi
  done

  # Substitute named placeholders ({name})
  for arg in "$@"; do
    if [[ "$arg" == *=* ]]; then
      local pkey="${arg%%=*}"
      local pval="${arg#*=}"
      msg="${msg//\{$pkey\}/$pval}"
    fi
  done

  echo "$msg"
}

# _get_yaml_value — Extract a dotted key value from a YAML file
# Internal helper, not exported
function _get_yaml_value() {
  local file="$1"
  local key="$2"

  # Split key into section and key parts
  local section="${key%.*}"
  local k="${key#*.}"

  # Use awk to extract the value
  awk -v section="$section" -v k="$k" '
    $1 == section ":" { in_section = 1; next }
    in_section && /^[a-zA-Z_]/ && !/^[[:space:]]/ { in_section = 0 }
    in_section {
      if ($1 == k ":") {
        # Extract value after "key: ", strip quotes
        sub(/^[[:space:]]*[a-zA-Z_]+:[[:space:]]*/, "")
        gsub(/^"|"$/, "")
        print
        exit
      }
    }
  ' "$file"
}

export -f t
export -f _get_yaml_value
