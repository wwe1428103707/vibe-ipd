# Feature Specification: VIPD Init Language Option

**Feature Branch**: `016-vipd-init-language`

**Created**: 2026-06-08

**Status**: Draft

**Input**: User description: "为vipd初始化添加一个语言选项，用户可以切换与vipd与自己交互时使用的语言，后续也可以用户自行去修改配置文件调整语言或在对话时手动指定"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Select Language During vipd Init (Priority: P1)

As a **user running vipd init for the first time**, I want to choose my preferred language during the initialization process, so that all subsequent vipd interactions (prompts, messages, confirmations) are displayed in my chosen language.

**Why this priority**: First-run experience sets the tone. If the user selects a language during init, every downstream interaction should respect that choice without additional configuration effort.

**Independent Test**: Can be validated by running `vipd init --lang zh` and confirming all init prompts appear in Chinese. Then run `vipd init --lang en` and confirm English output.

**Acceptance Scenarios**:

1. **Given** a fresh environment, **When** the user runs `vipd init --lang zh`, **Then** all initialization prompts, status messages, and help text are displayed in Chinese
2. **Given** a fresh environment, **When** the user runs `vipd init --lang en`, **Then** all initialization output is in English
3. **Given** a fresh environment, **When** the user runs `vipd init` without `--lang`, **Then** the system defaults to English (or the system language if detectable)

---

### User Story 2 - Language Persistence Across Sessions (Priority: P1)

As a **user who has completed vipd init**, I want my language choice to be persisted in the configuration file, so that I don't need to specify `--lang` every time I run a vipd command.

**Why this priority**: Persistence is essential for usability — requiring `--lang` on every command defeats the purpose of setting a language preference.

**Independent Test**: Run `vipd init --lang zh`, verify config file contains `language: zh`. Then run any other vipd command and confirm output is in Chinese without passing `--lang`.

**Acceptance Scenarios**:

1. **Given** vipd init completed with `--lang zh`, **When** I inspect `~/.vipd/config.yml` or the project's `.vipd/config.yml`, **Then** the file contains `language: zh`
2. **Given** a persisted language setting, **When** I run any vipd command, **Then** output uses the configured language without requiring the `--lang` flag
3. **Given** a persisted language setting, **When** I override it with `--lang en` on a specific command, **Then** that command runs in English without modifying the persistent config

---

### User Story 3 - Manual Language Override in Conversation (Priority: P2)

As a **user in the middle of a vipd session**, I want to temporarily switch the language by specifying it in the command, so that I can switch between languages without modifying the configuration file.

**Why this priority**: This addresses the "对话时手动指定" (manual specification during conversation) requirement — it's a convenience feature on top of the persistent setting.

**Independent Test**: With config set to `language: zh`, run a command with `--lang en` and verify English output. Then run the same command without `--lang` and confirm output reverts to Chinese.

**Acceptance Scenarios**:

1. **Given** a config with `language: zh`, **When** the user runs `vipd <command> --lang en`, **Then** output is in English for that command only
2. **Given** a config with `language: zh`, **When** the user runs `vipd <command>` (no --lang), **Then** output remains in Chinese
3. **Given** no config language set, **When** the user runs `vipd <command> --lang ja`, **Then** output is in Japanese for that command only

---

### User Story 4 - Edit Language in Configuration File (Priority: P2)

As a **user who wants to permanently change their language preference**, I want to edit a single line in the configuration file, so that I can switch languages without re-running vipd init.

**Why this priority**: This fulfills the "用户自行去修改配置文件调整语言" (user modifies config file to adjust language) requirement — it's a power-user feature.

**Independent Test**: Manually change `language: en` to `language: zh` in the config file, then run any vipd command and verify output is in Chinese.

**Acceptance Scenarios**:

1. **Given** a config file with `language: en`, **When** I edit it to `language: zh` and save, **Then** subsequent vipd commands use Chinese
2. **Given** an invalid language value in config (e.g., `language: xyz`), **When** vipd reads the config, **Then** it falls back to English and shows a warning
3. **Given** the config file exists but has no `language` key, **When** vipd reads it, **Then** it defaults to English

---

### Edge Cases

- What happens when `--lang` specifies an unsupported language? (vipd should warn and fall back to English)
- What happens when the config file contains a language code that was supported in an older version but is no longer available? (Fall back to English with a deprecation notice)
- How does language selection interact with existing multilingual features (e.g., the `--lang` flag on `hello.sh`)? (Should use the same language code conventions for consistency)
- What about CJK character rendering in terminals that don't support Unicode? (vipd should detect terminal encoding and warn if the selected language may not render correctly)

## TR Gate Assessment *(IPD only)*

- **Applicable TR Gates**: TR1 (spec), TR2/TR3 (plan), TR4 (implementation)
- **Risk Level**: Low — this is a straightforward configuration extension to the existing vipd init flow
- **Gate Evidence Required**:
  - Language configuration schema design
  - Language string resource file format
  - Integration with existing `--lang` convention (see feature 011)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The `vipd init` command MUST accept a `--lang` / `-l` parameter accepting language codes (e.g., `en`, `zh`, `ja`) to set the initialization language.
- **FR-002**: The system MUST persist the chosen language to a configuration file (`~/.vipd/config.yml` or project-local `.vipd/config.yml`) under a `language` key.
- **FR-003**: All vipd commands MUST respect the configured `language` value from the config file and display messages in that language.
- **FR-004**: The `--lang` flag MUST be available on all vipd commands to temporarily override the config file language for that single invocation.
- **FR-005**: When `--lang` is provided alongside a config file language, the CLI flag MUST take precedence for that command only (config file is NOT modified).
- **FR-006**: The system MUST support a minimum of two languages at launch: English (`en`) and Chinese (`zh`), with a documented extension mechanism for adding more.
- **FR-007**: If an unsupported language code is provided (via `--lang` or config), the system MUST fall back to English and output a warning message.
- **FR-008**: Language string resources MUST be stored in external files (e.g., `lang/en.yml`, `lang/zh.yml`) — not hardcoded in source — so that new languages can be added without modifying code.
- **FR-009**: The language configuration MUST be independent of and consistent with the existing `--lang` convention used by `hello.sh` (feature 011), sharing the same language code scheme.

### Key Entities *(include if feature involves data)*

- **Language Config**: A key-value pair in the config file: `language: <code>`. Persisted in YAML format. Supports codes like `en`, `zh`, `ja`.
- **Language String Resource**: An external file (`lang/<code>.yml`) containing all user-facing message strings in that language. Each file has the same set of keys, with translated values.
- **Language Registry**: The set of supported languages and their metadata (code, display name, locale). Defined in a configuration or discovered by scanning the `lang/` directory.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete `vipd init --lang zh` and see all init output in Chinese. A user with no prior knowledge of the feature can discover and use the `--lang` flag from `--help` output.
- **SC-002**: After init with `--lang zh`, all subsequent vipd commands (without `--lang`) display output in Chinese, confirmed across at least 5 different vipd commands.
- **SC-003**: A user can manually edit the config file's `language` key and see the change reflected in the next vipd command, without re-running init.
- **SC-004**: The `--lang` flag on any vipd command overrides the config file language for that invocation only, verified by running the same command twice (once with override, once without).
- **SC-005**: Adding a new language requires only: (a) creating a new `lang/<code>.yml` file with translated strings, and (b) restarting the session. No code changes needed.

## Assumptions

- English (`en`) is the default language — used when no config value is set and no `--lang` is provided.
- The existing `--lang` convention from feature 011 (multilingual greeting) provides the language code scheme — `en`, `zh`, `ja` — this feature follows the same convention for consistency.
- The config file location follows whatever convention vipd already uses (e.g., `~/.vipd/config.yml` or project-local `.vipd/config.yml`).
- Language string resource files follow a flat key-value YAML format, organized by command or message category.
- Not all messages need to be translated at launch — a fallback mechanism (missing key → English) is acceptable for v1.
- The feature applies to **vipd CLI commands only**, not to AI agent conversation language (which is a separate concern).

## Risk Register *(IPD only)*

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Incomplete translations — some messages remain in English | M | M | Implement English fallback for any missing translation key |
| Language code inconsistency between features (011 vs this) | M | L | Reuse same language code scheme; document in a shared reference |
| Config file parsing errors break language detection | M | L | Defensive parsing with English fallback on parse failure |
| CJK character rendering issues in some terminals | L | M | Detect terminal encoding; warn on launch if charset may not support selected language |
