"""Tests for language resolution logic — US1."""

import subprocess
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def _run_resolve(args=None):
    """Run resolve_language.sh and return VIPD_LANG value."""
    cmd = ["bash", "-c", f"""
        source {BASE_DIR}/.vipd/resolve_language.sh {" ".join(args or [])}
        echo "$VIPD_LANG"
    """]
    result = subprocess.run(cmd, capture_output=True, text=True, cwd=BASE_DIR)
    return result.stdout.strip()


def test_resolve_with_lang_zh():
    """T007: --lang zh returns zh as effective language."""
    lang = _run_resolve(["--lang", "zh"])
    assert lang == "zh", f"Expected 'zh', got '{lang}'"


def test_resolve_default_to_en():
    """T008: No config or flag returns en (default)."""
    lang = _run_resolve()
    assert lang == "en", f"Expected 'en', got '{lang}'"
