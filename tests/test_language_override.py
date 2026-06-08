"""Tests for language override — US3."""

import subprocess
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def test_cli_override_config():
    """T017: --lang en overrides config zh for that invocation only."""
    # Set config to zh
    config_path = os.path.join(BASE_DIR, ".vipd", "config.yml")
    with open(config_path, "w") as f:
        f.write("language: zh\n")

    # Run with --lang en override
    cmd = ["bash", "-c", f"""
        source {BASE_DIR}/.vipd/resolve_language.sh --lang en
        echo "RESULT=$VIPD_LANG"
    """]
    result = subprocess.run(cmd, capture_output=True, text=True, cwd=BASE_DIR)
    output = result.stdout.strip()
    assert "RESULT=en" in output, f"Expected override to en, got: {output}"

    # Verify config still has zh
    with open(config_path) as f:
        content = f.read()
    assert "language: zh" in content, "Config was modified by override!"

    # Reset config to en
    with open(config_path, "w") as f:
        f.write("language: en\n")


def test_subsequent_call_uses_config():
    """T018: After override, subsequent resolution (without --lang) still reads config."""
    config_path = os.path.join(BASE_DIR, ".vipd", "config.yml")
    with open(config_path, "w") as f:
        f.write("language: zh\n")

    # First call with override
    cmd1 = ["bash", "-c", f"""
        source {BASE_DIR}/.vipd/resolve_language.sh --lang en
        echo "OVERRIDE=$VIPD_LANG"
    """]
    subprocess.run(cmd1, capture_output=True, text=True, cwd=BASE_DIR)

    # Second call without override — should read config (zh)
    cmd2 = ["bash", "-c", f"""
        source {BASE_DIR}/.vipd/resolve_language.sh
        echo "PERSIST=$VIPD_LANG"
    """]
    result2 = subprocess.run(cmd2, capture_output=True, text=True, cwd=BASE_DIR)
    output2 = result2.stdout.strip()
    assert "PERSIST=zh" in output2, f"Expected zh from config, got: {output2}"

    # Reset config
    with open(config_path, "w") as f:
        f.write("language: en\n")
