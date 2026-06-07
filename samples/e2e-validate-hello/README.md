# e2e-validate-hello

A minimal "hello world" greeting CLI tool used for end-to-end validation of the IPD-Agile toolchain.

## Purpose

This project serves as a validation target for exercising the full specification-to-implementation pipeline of the [vibe-ipd](https://github.com/YuFJ/vibe-ipd) project. Its trivial scope (single greeting command) ensures that validation focuses on the toolchain behavior rather than debugging sample code.

## Usage

```bash
# Print a personalized greeting
bash hello.sh --name World
# Output: Hello, World! Welcome to the IPD-Agile toolchain validation.

# Show help
bash hello.sh --help

# Show version
bash hello.sh --version
```

## Validation Scope

- Specification → Plan → Tasks → Implementation → Analysis
- IPD gate compliance (TR0–TR6)
- CLI command (`/vipd-*`) functionality
