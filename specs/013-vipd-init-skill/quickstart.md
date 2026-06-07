# vipd-init Quickstart Guide

## Overview

`/vipd-init` is a Claude Code skill that initializes a new vibe-ipd project by wrapping the upstream speckit CLI (`specify init`). Think of it as a branded front door — you only need to remember `/vipd-init` instead of `specify init`.

## Basic Usage

### Create a new project

```bash
/vipd-init my-project --integration claude
cd my-project
```

This will:
1. Detect available tooling (prefers `uvx`, falls back to `pipx`)
2. Run `specify init my-project --integration claude` under the hood
3. Present you with scaffold results

### Initialize current directory

```bash
/vipd-init . --integration claude
```

## Options

| Flag | Description | Default |
|------|-------------|---------|
| `<PROJECT_NAME>` | Target directory name (or `.` for current dir) | Required |
| `--integration` | AI agent integration type (`claude`, `copilot`, etc.) | Required |

## What Gets Created

After running `/vipd-init my-project --integration claude`:

```
my-project/
├── .specify/              # Speckit/vibe-ipd structure
│   ├── scripts/           # PowerShell & Bash automation
│   ├── templates/         # Spec, plan, task templates
│   ├── integrations/      # Integration manifests
│   ├── memory/            # Constitution & project memory
│   └── extensions/        # Git & other extensions
├── .claude/
│   └── skills/            # AI coding agent skills
└── specs/                 # Feature specifications directory
```

## Prerequisites

- **uv** (recommended): Install from [docs.astral.sh/uv](https://docs.astral.sh/uv/)
- **pipx** (fallback): Install from [pipx.pypa.io](https://pipx.pypa.io/)

Verify with:
```bash
uv --version   # OR
pipx --version
```

## Examples

```bash
# Scaffold a web app with Claude integration
/vipd-init task-manager --integration claude

# Initialize in the current folder
/vipd-init . --integration claude

# After init, start using vibe-ipd commands
/vipd-constitution ...
/vipd-specify ...
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `uvx` not found | Install uv: `winget install astral.uv` (Win) or `curl -LsSf https://astral.sh/uv/install.sh | sh` (macOS/Linux) |
| `pipx` not found | Install pipx: `pip install pipx` |
| Directory already exists | `/vipd-init` will detect existing `.specify/` and warn |
| Network timeout | Retry; check connection to `github.com` |
