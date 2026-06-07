# CLI Contract: Hello Greeting Tool

## Sample Project: e2e-validate-hello

**Tool Name**: `hello.sh`

**Location**: `samples/e2e-validate-hello/hello.sh`

**Description**: A simple CLI greeting tool that prints a personalized greeting message.

---

## Command Interface

### `hello.sh --name <NAME>`

| Aspect | Specification |
|--------|--------------|
| **Purpose** | Print a personalized greeting |
| **Arguments** | `--name <NAME>` (required) — The name to greet |
| **Exit Code** | `0` on success |
| **Output** | `Hello, <NAME>! Welcome to the IPD-Agile toolchain validation.` |
| **Stderr** | Error messages if `--name` is missing |

### `hello.sh --help`

| Aspect | Specification |
|--------|--------------|
| **Purpose** | Display usage information |
| **Arguments** | None |
| **Exit Code** | `0` |
| **Output** | Usage instructions showing all available options |

### `hello.sh --version`

| Aspect | Specification |
|--------|--------------|
| **Purpose** | Display tool version |
| **Arguments** | None |
| **Exit Code** | `0` |
| **Output** | `e2e-validate-hello v1.0.0` |

---

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Missing required argument |
| `2` | Unknown option |

---

## Behavior Rules

1. The greeting MUST include the exact name provided via `--name`, without transformation.
2. If `--name` is not provided, the script MUST print an error to stderr and exit with code 1.
3. If an unknown option is provided, the script MUST print an error and exit with code 2.
4. The script MUST be executable (`chmod +x hello.sh`).
5. Output MUST be written to stdout only (not stderr) for success cases.
