# Quickstart: VIPD Init Language Option

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md) | **Spec**: [spec.md](spec.md)

## Implementation Steps

### Step 1: Create Language Resource Files

**`lang/en.yml`** — English (default):
```yaml
_meta:
  code: en
  display_name: English

init:
  welcome: "Welcome to vipd project initialization!"
  project_name: "Project name"
  language_select: "Select your preferred language"
  complete: "Initialization complete!"
  usage: "Usage: /vipd-init <PROJECT_NAME> [--integration <TYPE>] [--script ps|sh] [--lang <CODE>]"

error:
  network: "Network error: unable to reach GitHub."
  no_tool: "No supported tool found. Install uv or pipx to continue."
  invalid_lang: "Unsupported language '{code}'. Falling back to English."
  missing_project: "Usage: /vipd-init <PROJECT_NAME> [--lang <CODE>]"

help:
  lang_flag: "Set interaction language (en, zh, ja, ...)"
```

**`lang/zh.yml`** — Chinese:
```yaml
_meta:
  code: zh
  display_name: 中文

init:
  welcome: "欢迎使用 vipd 项目初始化！"
  project_name: "项目名称"
  language_select: "请选择您偏好的语言"
  complete: "初始化完成！"
  usage: "用法：/vipd-init <项目名称> [--integration <类型>] [--script ps|sh] [--lang <代码>]"

error:
  network: "网络错误：无法连接到 GitHub。"
  no_tool: "未找到支持的工具。请安装 uv 或 pipx 后重试。"
  invalid_lang: "不支持的语言 '{code}'，将回退到英文。"
  missing_project: "用法：/vipd-init <项目名称> [--lang <代码>]"

help:
  lang_flag: "设置交互语言（en, zh, ja, ...）"
```

---

### Step 2: Create Config Directory and Default Config

```bash
mkdir -p .vipd
```

Create `.vipd/config.yml` if it doesn't exist:
```yaml
# vipd project configuration
# language: Set interaction language (en, zh, ja, ...)
language: en
```

---

### Step 3: Extend SKILL.md — Add `--lang` Parameter

In `.claude/skills/vipd-init/SKILL.md`, modify the User Input section to accept `--lang`:

```markdown
Parse the input to extract:
- `<PROJECT_NAME>` — target directory name, or `.` for current directory (REQUIRED)
- `--integration <TYPE>` — AI coding agent integration type (optional, default: none)
- `--script ps|sh` — explicit script type selection (optional)
- `--lang <CODE>` — interaction language (optional, default: en)
```

Add a Pre-Execution step to resolve the language:

```markdown
### 3. Resolve interaction language

Determine the language to use by priority:
1. If `--lang <CODE>` was provided in arguments → use it (no config update)
2. Else if `.vipd/config.yml` has `language` key → use it
3. Else → default to `en`

Validate the language code is supported (check `lang/<code>.yml` exists).
If unsupported, warn and fall back to `en`.
```

---

### Step 4: Add Language-Aware Output

Replace all hardcoded English strings in SKILL.md with language-aware lookups. For example:

```
Before:
> "❌  No supported tool found."

After:
> Get-LanguageString "error.no_tool" (resolves to "❌  No supported tool found." in en, or translated equivalent)
```

Create a language resolver module that:
1. Loads the language resource file based on resolved language
2. Provides a `t(key)` function for string lookup with English fallback
3. Caches the loaded strings for the session duration

---

### Step 5: Wire `--lang` to All vipd Commands

For each vipd command SKILL.md:
- Add `--lang` parameter parsing
- Source the language resolver
- Replace hardcoded output strings with `t("section.key")` calls

Commands to update:
- `vipd-init` (primary — language selection during init)
- `vipd-constitution`
- `vipd-specify`
- `vipd-plan`
- `vipd-tasks`
- `vipd-implement`

### Step 6: Language Resolution Script

Create a reusable script `.vipd/resolve_language.sh` (Bash) or equivalent Python module:

```bash
# resolve_language.sh
# Usage: source .vipd/resolve_language.sh --lang $LANG_ARG
# Sets $VIPD_LANG variable

VIPD_LANG="en"

# Check --lang arg
for arg in "$@"; do
  if [ "$arg" = "--lang" ]; then
    shift
    VIPD_LANG="$1"
    break
  fi
done

# Check project config
if [ "$VIPD_LANG" = "en" ] && [ -f ".vipd/config.yml" ]; then
  CONFIG_LANG=$(grep '^language:' .vipd/config.yml | awk '{print $2}')
  [ -n "$CONFIG_LANG" ] && VIPD_LANG="$CONFIG_LANG"
fi

# Validate
if [ ! -f "lang/$VIPD_LANG.yml" ]; then
  echo "Warning: Unsupported language '$VIPD_LANG'. Falling back to English." >&2
  VIPD_LANG="en"
fi
```

## Verification Checklist

- [ ] `vipd init --lang zh` shows all prompts in Chinese
- [ ] `vipd init --lang en` shows all prompts in English
- [ ] `vipd init` without `--lang` defaults to English
- [ ] `.vipd/config.yml` contains `language: zh` after `--lang zh`
- [ ] Subsequent commands without `--lang` use the config language
- [ ] `--lang en` on a command overrides config `zh` for that command only
- [ ] Invalid `--lang xyz` falls back to English with a warning
- [ ] Missing config file defaults to English without error
- [ ] `lang/en.yml` missing a key falls back gracefully (no crash)
