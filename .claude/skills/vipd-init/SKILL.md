---
name: "vipd-init"
description: "Initialize a new vibe-ipd project by scaffolding with the upstream speckit CLI (specify init)."
argument-hint: "<PROJECT_NAME> [--integration claude|claude-code|copilot] [--script ps|sh] [--lang en|zh|ja]"
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
- `--lang <CODE>` — interaction language code (optional, default: en)

**Examples**:
- `/vipd-init my-app --integration claude` → scaffold `my-app/` with Claude integration
- `/vipd-init . --integration claude` → scaffold in current directory with Claude integration
- `/vipd-init my-app --integration claude-code` → scaffold with Claude Code Workflow mode (auto-generates Workflow scripts in vipd-tasks, parallel execution in vipd-implement)
- `/vipd-init my-app` → scaffold `my-app/` without integration-specific files
- `/vipd-init my-app --lang zh` → scaffold with Chinese language output
- `/vipd-init my-app --integration copilot --lang ja` → scaffold with Copilot + Japanese

**If PROJECT_NAME is missing**: Halt with error: "$(t error.missing_project)"

## Pre-Execution Checks

### 1. Validate target directory

Check if the target directory already has a `.specify/` subdirectory:

- If PROJECT_NAME is `.` (current directory):
  - Check if `$(pwd)/.specify/` exists (Linux/macOS) or `$PWD\.specify\` (Windows)
- If PROJECT_NAME is a new directory name:
  - Check if `./<PROJECT_NAME>/.specify/` exists
- **If `.specify/` exists**: Warn the user:
  > "⚠️  $(t error.target_exists)"
  Wait for user response. If "no" or empty, halt with: "$(t error.init_cancelled)"

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
- **If neither found**: Halt with clear error message using a localized error string:
  ```bash
  echo "❌  $(t error.no_tool)"
  ```
  After installing one, re-run /vipd-init.

### 3. Resolve interaction language

Resolve the effective language for this session:

```bash
# Source the language resolver (parses --lang from args, then checks config)
source .vipd/resolve_language.sh --lang "$LANG_ARG"
source .vipd/load_strings.sh
# VIPD_LANG and t() function are now available
```

Language priority: `--lang` CLI flag > `.vipd/config.yml` > `~/.vipd/config.yml` > `en` default.

## Execution

### Step 1: Resolve language and prompt user if not specified

If `--lang` was provided in the arguments, it was already resolved. If not, prompt the user to select a language:

```bash
if [[ -z "$LANG_ARG" ]]; then
  echo "$(t init.language_select)"
  echo "  1) English (en)"
  echo "  2) 中文 (zh)"
  read -p "$(t init.language_choice codes=en,zh): " LANG_CHOICE
  case $LANG_CHOICE in
    1|en|English) LANG_ARG="en" ;;
    2|zh|zhongwen|中文) LANG_ARG="zh" ;;
    *) LANG_ARG="en" ;;
  esac
  source .vipd/resolve_language.sh --lang "$LANG_ARG"
  source .vipd/load_strings.sh
fi
```

### Step 2: Build the scaffold command

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

### Step 3: Append optional flags

If `--integration <TYPE>` was provided:
- Append `--integration <TYPE>` to the `specify init` command

If `--script ps|sh` was provided:
- Append `--script <ps|sh>` to the `specify init` command

If `--lang <CODE>` was provided:
- The language is already resolved via `resolve_language.sh` — no need to pass to `specify init`

**Important**: Forward all `--integration` and `--script` values verbatim — do not validate or restrict them.

### Step 4: Execute scaffolding

Run the constructed command.

**On success**: Proceed to Step 5 (Post-Init Branding).

**On failure**: Show localized error:
  ```bash
  echo "❌  $(t error.scaffolding_failed details="$ERROR_DETAILS")"
  ```

### Step 5: Post-Init Mode Setting (Claude Code only)

If `--integration claude-code` was provided:
1. After scaffolding succeeds, navigate into the project directory (if PROJECT_NAME is not `.`)
2. Create or update `.vipd/config.yml` to add `mode: claude-code`:
   ```bash
   # Add mode to .vipd/config.yml
   if [ -f ".vipd/config.yml" ]; then
     if grep -q "^mode:" .vipd/config.yml; then
       sed -i 's/^mode:.*/mode: claude-code/' .vipd/config.yml
     else
       echo "mode: claude-code" >> .vipd/config.yml
     fi
   else
     echo -e "language: en\nmode: claude-code" > .vipd/config.yml
   fi
   ```
3. Log confirmation: `"[vipd-init] Claude Code workflow mode enabled"`

### Step 6: Post-Init Branding (Optional)

After scaffolding succeeds (and mode setting if applicable), check what was created:

1. **Inventory newly created skills**: List `.claude/skills/` in the target project.
2. **Detect `speckit-*` skills**: If any `speckit-*` prefixed skills are found:
   ```
   ℹ️  $(t info.branding_note)

   Options:
   - $(t info.keep_skills)
   - $(t info.replace_skills)
   ```
3. **Recommend next command**:
   ```
   ✅  $(t init.complete)

   $(t init.next_steps project=<PROJECT_NAME>)
   ```

### Step 6: Completion Reporting

Report completion to the user with:

```
✅  /vipd-init complete

   Target:     <PROJECT_NAME>
   Integration: <TYPE> (or 'none')
   Tool used:  uvx (or pipx)
   Language:   $VIPD_LANG

   Quickstart:
   cd <PROJECT_NAME>
   /vipd-constitution $(t help.integration_flag)
   /vipd-specify $(t help.project_arg)

   Troubleshooting:
   /vipd-init --help  — Show usage info
```

## Edge Cases

### Project name is `.` (current directory)

Run `specify init .` in the current directory. All scaffolding files are placed directly in `$(pwd)`.

### Project name contains spaces or special characters

Pass the name through to `specify init` as provided — the upstream CLI handles quoting.

### Already in a git repository with .specify/

The pre-check detects this and asks for confirmation. If user confirms, re-initialization proceeds (upstream `specify init` handles overwrite protection for individual files).

### Network timeout during scaffolding

If the `uvx` or `pipx` command fails with a network-related error, display a localized message:
```bash
echo "❌  $(t error.network)"
```

### `--integration` not provided

Scaffold without `--integration` flag. Inform user that integration-specific skill files were not created, and they can re-run with `--integration claude` if desired.

### Unsupported language code

If `--lang xyz` is provided where `xyz` is not a supported language code, the resolver falls back to English and displays a warning. The `t()` function always has English fallback for missing keys, so no message will be empty.

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
