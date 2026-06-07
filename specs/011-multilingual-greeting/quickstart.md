# Quickstart: Multilingual Greeting

## Test Scenarios

### English (default)
```bash
bash samples/e2e-validate-hello/hello.sh --name Alice --lang en
# Expected: Hello, Alice! Welcome to the IPD-Agile toolchain validation.
```

### Chinese
```bash
bash samples/e2e-validate-hello/hello.sh --name 小明 --lang zh
# Expected: 你好，小明！欢迎来到IPD-Agile工具链验证。
```

### Japanese
```bash
bash samples/e2e-validate-hello/hello.sh --name 田中 --lang ja
# Expected: こんにちは、田中さん！IPD-Agileツールチェーン検証へようこそ。
```

### Default (no --lang)
```bash
bash samples/e2e-validate-hello/hello.sh --name Bob
# Expected: Hello, Bob! Welcome to the IPD-Agile toolchain validation.
```

### Invalid language code
```bash
bash samples/e2e-validate-hello/hello.sh --name Test --lang fr
# Expected: Hello, Test! ... (with stderr notice about fallback)
```
