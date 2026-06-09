---
name: "vipd-config-mode"
description: "Set or view the VIPD project mode (standard | claude-code) in .vipd/config.yml"
argument-hint: "set <standard|claude-code>"
metadata:
  author: "vibe-ipd"
  source: "specs/018-claude-code-workflow"
user-invocable: true
disable-model-invocation: false
---

## User Input

```text
$ARGUMENTS
```

Parse the input to extract the action:
- `set <standard|claude-code>` — set the project mode
- (no args) — display the current mode

**Examples**:
- `/vipd-config-mode set claude-code` → enable Claude Code Workflow mode
- `/vipd-config-mode set standard` → revert to standard mode
- `/vipd-config-mode` → display current mode

## Execution

### Step 1: Read current mode

Read `.vipd/config.yml` and check for the `mode` field:

```bash
MODE="standard"
if [ -f ".vipd/config.yml" ]; then
  FOUND_MODE=$(grep -E '^mode:' .vipd/config.yml | sed 's/^mode:[[:space:]]*//')
  if [ -n "$FOUND_MODE" ]; then
    MODE="$FOUND_MODE"
  fi
fi
```

### Step 2: Execute requested action

**If no args** (display mode):
```bash
echo "Current mode: $MODE"
echo ""
echo "Available: standard | claude-code"
echo "To change: /vipd-config-mode set <mode>"
```

**If `set <new_mode>`**:
```bash
NEW_MODE="$2"
if [ "$NEW_MODE" != "standard" ] && [ "$NEW_MODE" != "claude-code" ]; then
  echo "❌ Invalid mode: $NEW_MODE"
  echo "Valid modes: standard, claude-code"
  exit 1
fi

if [ ! -f ".vipd/config.yml" ]; then
  echo -e "language: en\nmode: $NEW_MODE" > .vipd/config.yml
else
  if grep -qE '^mode:' .vipd/config.yml; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      sed -i '' "s/^mode:.*/mode: $NEW_MODE/" .vipd/config.yml
    else
      sed -i "s/^mode:.*/mode: $NEW_MODE/" .vipd/config.yml
    fi
  else
    echo "mode: $NEW_MODE" >> .vipd/config.yml
  fi
fi

echo "✅ Mode set to: $NEW_MODE"
echo ""

if [ "$NEW_MODE" = "claude-code" ]; then
  echo "ℹ️  Claude Code Workflow mode enabled."
  echo "   Next /vipd-tasks will auto-generate Workflow scripts."
  echo "   Next /vipd-implement will execute via Workflow tool."
else
  echo "ℹ️  Standard mode active."
fi
```

## Related Commands

- `/vipd-init --integration claude-code` — Initialize project with Claude Code mode
- `/vipd-tasks` — Generate tasks (auto-generates Workflow script in claude-code mode)
- `/vipd-implement` — Execute implementation (uses Workflow tool in claude-code mode)
