---
name: "vipd-init"
description: "Initialize a new vibe-ipd project by scaffolding with the upstream speckit CLI (specify init)."
argument-hint: "<PROJECT_NAME> [--integration claude|copilot] [--script ps|sh]"
compatibility: "Requires uvx (recommended) or pipx for upstream CLI delegation"
metadata:
  author: "vibe-ipd"
  source: "specs/013-vipd-init-skill"
user-invocable: true
disable-model-invocation: false
---


## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

Parse the input to extract:
- `<PROJECT_NAME>` — target directory name, or `.` for current directory (REQUIRED)
- `--integration <TYPE>` — AI coding agent integration type (optional, default: none)
- `--script ps|sh` — explicit script type selection (optional)

**Examples**:
- `/vipd-init my-app --integration claude` → scaffold `my-app/` with Claude integration
- `/vipd-init . --integration claude` → scaffold in current directory with Claude integration
- `/vipd-init my-app` → scaffold `my-app/` without integration-specific files
- `/vipd-init my-app --integration copilot` → scaffold with Copilot integration

**If PROJECT_NAME is missing**: Halt with error: "Usage: /vipd-init <PROJECT_NAME> [--integration <TYPE>] [--script ps|sh]"

## Pre-Execution Checks

### 1. Validate target directory

Check if the target directory already has a `.specify/` subdirectory:

- If PROJECT_NAME is `.` (current directory):
  - Check if `$(pwd)/.specify/` exists (Linux/macOS) or `$PWD\.specify\` (Windows)
- If PROJECT_NAME is a new directory name:
  - Check if `./<PROJECT_NAME>/.specify/` exists
- **If `.specify/` exists**: Warn the user:
  > "⚠️  Target already contains `.specify/`. Re-initializing may overwrite existing configuration. Continue? (yes/no)"
  Wait for user response. If "no" or empty, halt with: "Init cancelled by user."

### 2. Detect available tooling

Check for `uvx` and `pipx` availability:

```bash
# Check uvx (preferred)
uvx --version 2>/dev/null && echo "UVX_AVAILABLE" || echo "UVX_NOT_FOUND"

# Check pipx (fallback)
pipx --version 2>/dev/null && echo "PIPX_AVAILABLE" || echo "PIPX_NOT_FOUND"
```

- **If uvx found**: Use `uvx` as the primary delegation method (preferred — no persistent install needed).
- **If uvx not found but pipx found**: Use `pipx` as fallback.
- **If neither found**: Halt with clear error message:
  ```
  ❌  No supported tool found.

  To initialize a vibe-ipd project, you need one of:
  1. **uv** (recommended): https://docs.astral.sh/uv/
  2. **pipx**: https://pipx.pypa.io/

  After installing one, re-run /vipd-init.

  Manual setup alternative:
  ┌─────────────────────────────────────────────────────┐
  │ uvx --from git+https://github.com/github/spec-kit  │
  │   .git specify init <PROJECT_NAME>                  │
  │                                                     │
  │ # OR if you already cloned spec-kit:                │
  │ specify init <PROJECT_NAME>                         │
  └─────────────────────────────────────────────────────┘
  ```

## Execution

### Step 1: Build the scaffold command

Construct the delegation command based on detected tooling:

**uvx path** (primary):
```bash
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

**pipx path** (fallback):
```bash
pipx install git+https://github.com/github/spec-kit.git 2>/dev/null
specify init <PROJECT_NAME>
```

### Step 2: Append optional flags

If `--integration <TYPE>` was provided:
- Append `--integration <TYPE>` to the `specify init` command
- Example: `specify init my-app --integration claude`

If `--script ps|sh` was provided:
- Append `--script <ps|sh>` to the `specify init` command

**Important**: Forward all `--integration` and `--script` values verbatim — do not validate or restrict them. This ensures forward compatibility with new integration types added by the upstream speckit project.

### Step 3: Execute scaffolding

Run the constructed command.

**On success**: Proceed to Step 4 (Post-Init Branding).

**On failure**: Present the error output to the user along with manual setup instructions:
  ```
  ❌  Scaffolding failed: [error details]

  You can try manually:
  uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --integration claude

  If the issue persists, check:
  - Network connectivity to github.com
  - Whether uv/pipx is up to date
  ```

### Step 4: Post-Init Branding (Optional)

After scaffolding succeeds, check what was created:

1. **Inventory newly created skills**: List `.claude/skills/` in the target project.
2. **Detect `speckit-*` skills**: If any `speckit-*` prefixed skills are found:
   ```
   ℹ️  The scaffolded project includes upstream speckit skills (speckit-*).

   vibe-ipd provides enhanced alternatives (vipd-*). Options:
   - Keep speckit-* skills as-is (upstream default)
   - Replace with vipd-* skills if your vibe-ipd environment has them

   No changes are made automatically. The existing vipd-* skills in YOUR
   current project are NOT affected — this only reports what was created
   in the TARGET project.
   ```
3. **Recommend next command**:
   ```
   ✅  Project scaffolded successfully!

   Next steps:
   cd <PROJECT_NAME>
   /vipd-constitution Establish your project's principles
   /vipd-specify Describe your first feature
   ```

### Step 5: Completion Reporting

Report completion to the user with:

```
✅  /vipd-init complete

   Target:     <PROJECT_NAME>
   Integration: <TYPE> (or 'none')
   Tool used:  uvx (or pipx)

   What was created:
   - .specify/        — Core toolkit structure
   - .claude/skills/  — AI agent integration skills (speckit-*)
   - specs/           — Feature specifications directory

   Quickstart:
   cd <PROJECT_NAME>
   /vipd-constitution Create project principles
   /vipd-specify Define your first feature

   Troubleshooting:
   /vipd-init --help  — Show this usage info
```

## Edge Cases

### Project name is `.` (current directory)

Run `specify init .` in the current directory. All scaffolding files are placed directly in `$(pwd)`.

### Project name contains spaces or special characters

Pass the name through to `specify init` as provided — the upstream CLI handles quoting.

### Already in a git repository with .specify/

The pre-check detects this and asks for confirmation. If user confirms, re-initialization proceeds (upstream `specify init` handles overwrite protection for individual files).

### Network timeout during scaffolding

If the `uvx` or `pipx` command fails with a network-related error, display:
```
❌  Network error: unable to reach GitHub.

Please check your internet connection and try again.
Manual fallback: git clone https://github.com/github/spec-kit.git
```

### `--integration` not provided

Scaffold without `--integration` flag. Inform user that integration-specific skill files were not created, and they can re-run with `--integration claude` if desired.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "uvx: command not found" | Install uv: `winget install astral.uv` (Windows), `curl -LsSf https://astral.sh/uv/install.sh \| sh` (macOS/Linux) |
| "pipx: command not found" | `pip install pipx` or `brew install pipx` |
| "Network error" | Check connection; retry; try `git clone https://github.com/github/spec-kit.git` manually |
| "Directory exists and is not empty" | Use a different PROJECT_NAME or initialize in current directory with `/vipd-init .` |
| "Permission denied" | Ensure you have write permission in the target location |

## Related Commands

- `/vipd-constitution` — Define project principles and IPD governance after init
- `/vipd-specify` — Create feature specifications with user stories
- `/vipd-plan` — Generate implementation plans with architecture decisions
- `/vipd-tasks` — Break down plans into actionable task lists
- `/vipd-implement` — Execute tasks and build the feature
