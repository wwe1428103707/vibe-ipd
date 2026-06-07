#!/usr/bin/env bash
# e2e-validate-hello — A minimal greeting CLI tool for workflow validation
# Usage: bash hello.sh --name <NAME>

set -euo pipefail

VERSION="e2e-validate-hello v1.0.0"

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

A simple CLI greeting tool.

Options:
  --name <NAME>  Your name to greet (required)
  --help         Show this help message
  --version      Show version information
EOF
}

# No arguments
if [ $# -eq 0 ]; then
    echo "Error: --name argument is required" >&2
    usage
    exit 1
fi

NAME=""

while [ $# -gt 0 ]; do
    case "$1" in
        --name)
            if [ -z "${2:-}" ]; then
                echo "Error: --name requires a value" >&2
                exit 1
            fi
            NAME="$2"
            shift 2
            ;;
        --help)
            usage
            exit 0
            ;;
        --version)
            echo "$VERSION"
            exit 0
            ;;
        *)
            echo "Error: Unknown option: $1" >&2
            usage
            exit 2
            ;;
    esac
done

if [ -z "$NAME" ]; then
    echo "Error: --name argument is required" >&2
    usage
    exit 1
fi

echo "Hello, ${NAME}! Welcome to the IPD-Agile toolchain validation."
exit 0
