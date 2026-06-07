# CLI Contract: Multilingual Greeting Extension

## Command Interface Updates

### `hello.sh --name <NAME> --lang <CODE>`

| Aspect | Specification |
|--------|--------------|
| **Purpose** | Print a personalized, localized greeting |
| **Arguments** | `--name <NAME>` (required), `--lang <CODE>` (optional, default: `en`) |
| **Valid `<CODE>` values** | `en`, `zh`, `ja` |
| **Exit Code** | `0` on success |
| **Output** | Localized greeting per language template |
| **Stderr** | Notice if unsupported lang code provided; errors if `--name` missing |

## Language-Specific Behavior

| Code | Example Output |
|------|---------------|
| `en` | `Hello, World! Welcome to the IPD-Agile toolchain validation.` |
| `zh` | `你好，世界！欢迎来到IPD-Agile工具链验证。` |
| `ja` | `こんにちは、Worldさん！IPD-Agileツールチェーン検証へようこそ。` |

## Error Handling

| Condition | Exit Code | Stderr Output |
|-----------|-----------|---------------|
| Unsupported `--lang` code | 0 (success, with fallback) | `Warning: Unsupported language code '<code>'. Falling back to English.` |
| `--lang` without value | 1 | `Error: --lang requires a value` |
| `--name` missing | 1 | `Error: --name argument is required` |
