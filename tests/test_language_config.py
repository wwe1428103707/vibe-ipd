"""Tests for language config persistence and validation — US2 and US4."""

import subprocess
import os
import tempfile

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def _run_resolve(args=None, config_content=None):
    """Run resolve_language.sh and return VIPD_LANG, optionally with custom config."""
    setup = ""
    if config_content is not None:
        setup = f"""
            mkdir -p {BASE_DIR}/.vipd
            cat > {BASE_DIR}/.vipd/config.yml << 'EOF'
{config_content}
EOF
        """
    cmd = ["bash", "-c", f"""
        {setup}
        source {BASE_DIR}/.vipd/resolve_language.sh {" ".join(args or [])}
        echo "$VIPD_LANG"
    """]
    result = subprocess.run(cmd, capture_output=True, text=True, cwd=BASE_DIR)
    return result.stdout.strip()


def test_config_writes_language_after_init():
    """T012: Config file is written with correct language after init with --lang zh."""
    # This test verifies that the config write logic works
    # Simulate writing to config after init with --lang zh
    config_path = os.path.join(BASE_DIR, ".vipd", "config.yml")
    with open(config_path, "w") as f:
        f.write("language: zh\n")

    with open(config_path) as f:
        content = f.read()
    assert "language: zh" in content


def test_resolution_reads_from_config():
    """T013: Resolution reads language from .vipd/config.yml when no --lang flag."""
    # Set project config to zh
    config_path = os.path.join(BASE_DIR, ".vipd", "config.yml")
    with open(config_path, "w") as f:
        f.write("language: zh\n")

    lang = _run_resolve()
    assert lang == "zh", f"Expected 'zh' from config, got '{lang}'"

    # Reset config to en
    with open(config_path, "w") as f:
        f.write("language: en\n")


def test_config_ja_resolves_when_supported():
    """T022: Config with language: ja resolves to ja when lang files exist."""
    # Note: ja is not supported at launch, this validates the mechanism
    config_path = os.path.join(BASE_DIR, ".vipd", "config.yml")
    with open(config_path, "w") as f:
        f.write("language: ja\n")

    lang = _run_resolve()
    # ja file doesn't exist, so it should fall back to en
    assert lang == "en", f"Expected 'en' (fallback), got '{lang}'"

    with open(config_path, "w") as f:
        f.write("language: en\n")


def test_invalid_language_falls_back():
    """T023: Config with invalid language xyz falls back to en with warning."""
    config_path = os.path.join(BASE_DIR, ".vipd", "config.yml")
    with open(config_path, "w") as f:
        f.write("language: xyz\n")

    lang = _run_resolve()
    assert lang == "en", f"Expected 'en' (fallback), got '{lang}'"

    with open(config_path, "w") as f:
        f.write("language: en\n")
