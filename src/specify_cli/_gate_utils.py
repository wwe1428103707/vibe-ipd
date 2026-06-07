"""IPD gate enforcement utilities for the Python CLI layer.

Integrates with existing PS1/Bash gate scripts via subprocess invocation,
following the SpecKit ShellStep pattern from workflows/steps/shell/__init__.py.
"""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path
from typing import Optional

from rich.console import Console
from rich.table import Table

__all__ = [
    "GateError",
    "GateBlockedError",
    "GateOrderError",
    "GateScriptError",
    "detect_ipd_mode",
    "check_gate",
    "record_gate",
    "get_gate_status",
    "enforce_gate",
    "require_gate",
]

console = Console()

GATE_ORDER = ("TR0", "TR1", "TR2_TR3", "TR4", "TR4A", "TR5", "TR6")


# ---------------------------------------------------------------------------
# Exception hierarchy
# ---------------------------------------------------------------------------

class GateError(Exception):
    """Base exception for gate operations."""


class GateBlockedError(GateError):
    """Raised when a hard gate check fails.

    Attributes:
        gate: The gate ID that failed.
        failed_criteria: List of Must-Meet criteria that were not met.
        remediation: Suggested actions to pass the gate.
    """

    def __init__(
        self,
        gate: str,
        failed_criteria: list[str],
        remediation: str,
    ) -> None:
        self.gate = gate
        self.failed_criteria = failed_criteria
        self.remediation = remediation
        super().__init__(f"Gate {gate} blocked: {len(failed_criteria)} criteria not met")


class GateOrderError(GateError):
    """Raised when gate recording is attempted out of order."""


class GateScriptError(GateError):
    """Raised when a gate script fails to execute or returns invalid JSON."""


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

def _detect_script_type() -> str:
    """Return 'ps' on Windows, 'sh' on other platforms."""
    return "ps" if sys.platform == "win32" else "sh"


def _resolve_feature_dir(project_root: Path) -> Optional[str]:
    """Read .specify/feature.json and return the feature_directory value."""
    feature_file = project_root / ".specify" / "feature.json"
    if not feature_file.is_file():
        return None
    try:
        data = json.loads(feature_file.read_text(encoding="utf-8"))
        return data.get("feature_directory")
    except (json.JSONDecodeError, OSError):
        return None


def _run_gate_script(
    project_root: Path,
    script_name: str,
    args: list[str],
) -> dict:
    """Run a gate script via subprocess and parse JSON output.

    Args:
        project_root: Project root for cwd.
        script_name: Script filename (e.g., 'gate-check.ps1').
        args: Arguments to pass to the script.

    Returns:
        Parsed JSON output from the script.

    Raises:
        GateScriptError: On non-zero exit code or invalid JSON.
    """
    variant_dir = "powershell" if _detect_script_type() == "ps" else "bash"
    script_path = project_root / ".specify" / "scripts" / variant_dir / script_name

    if not script_path.is_file():
        raise GateScriptError(
            f"Gate script not found: {script_path}\n"
            f"Run 'specify init' to install gate scripts."
        )

    if _detect_script_type() == "ps":
        cmd = ["pwsh", "-NoProfile", "-File", str(script_path)] + args
    else:
        cmd = ["bash", str(script_path)] + args

    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            cwd=str(project_root),
            timeout=30,
        )
    except subprocess.TimeoutExpired:
        raise GateScriptError(
            f"Gate script {script_name} timed out after 30 seconds."
        )
    except OSError as exc:
        raise GateScriptError(
            f"Failed to run gate script {script_name}: {exc}"
        )

    # Gate scripts may write non-JSON output (oh-my-posh init errors, etc.)
    # before the JSON payload.  Find the last line that looks like JSON.
    output_lines = result.stdout.strip().splitlines() if result.stdout.strip() else []
    json_line = ""
    for line in reversed(output_lines):
        stripped = line.strip()
        if stripped.startswith("{"):
            json_line = stripped
            break

    if not json_line:
        raise GateScriptError(
            f"Gate script {script_name} produced no JSON output.\n"
            f"stderr: {result.stderr[:500] if result.stderr else '(none)'}"
        )

    try:
        data = json.loads(json_line)
    except json.JSONDecodeError as exc:
        raise GateScriptError(
            f"Gate script {script_name} returned invalid JSON: {exc}"
        )

    if result.returncode != 0 and not json_line:
        raise GateScriptError(
            f"Gate script {script_name} exited with code {result.returncode}: "
            f"{result.stderr[:500] if result.stderr else ''}"
        )

    return data


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def detect_ipd_mode(project_root: Path) -> bool:
    """Detect whether IPD mode is active.

    IPD mode is active when the constitution contains a
    'Gate Criteria Reference' section.
    """
    try:
        data = _run_gate_script(
            project_root,
            "gate-detect-ipd-mode.ps1" if _detect_script_type() == "ps" else "gate-detect-ipd-mode.sh",
            ["-Json"],
        )
        return bool(data.get("ipd_mode", False))
    except GateScriptError:
        return False


def check_gate(
    project_root: Path,
    gate: str,
    feature_dir: Optional[str] = None,
) -> dict:
    """Run gate-check script for the specified gate.

    Args:
        project_root: Absolute path to the project root.
        gate: Gate ID (TR0-TR6).
        feature_dir: Override feature directory.

    Returns:
        Parsed gate check result dict.

    Raises:
        GateBlockedError: If the gate check fails (hard gate model).
        GateScriptError: If the script fails or returns invalid JSON.
    """
    args = ["-Gate", gate, "-Json"]
    if feature_dir:
        args.extend(["-FeatureDir", feature_dir])

    script = "gate-check.ps1" if _detect_script_type() == "ps" else "gate-check.sh"
    data = _run_gate_script(project_root, script, args)

    if data.get("status") == "failed":
        current = data.get("current_gate", {})
        errors = current.get("errors", []) + data.get("errors", [])
        must_meet = current.get("must_meet_details", [])
        failed = [m for m in must_meet if not m.get("matched", False)]

        # Build remediation guidance
        prior = [pg["gate"] for pg in data.get("prior_gates", [])
                 if pg.get("status") != "passed"]
        remediation_parts = []
        if prior:
            remediation_parts.append(
                f"Prerequisite gates not passed: {', '.join(prior)}"
            )
        if failed:
            remediation_parts.append(
                "Missing content: " + "; ".join(
                    f"{f['criterion']} (pattern: {f.get('pattern', '?')})"
                    for f in failed
                )
            )
        if not prior and not failed:
            remediation_parts.append(
                "Review the gate criteria in the constitution's "
                "Gate Criteria Reference section."
            )

        raise GateBlockedError(
            gate=gate,
            failed_criteria=[e for e in errors if e],
            remediation=". ".join(remediation_parts),
        )

    return data


def record_gate(
    project_root: Path,
    gate: str,
    status: str,
    evidence: str,
    decision: str = "",
    decision_maker: str = "",
    decision_rationale: str = "",
    feature_dir: Optional[str] = None,
) -> dict:
    """Run gate-record script to update gate status.

    Raises:
        GateOrderError: If recording is out of order.
        GateScriptError: If the script fails.
    """
    args = ["-Gate", gate, "-Status", status, "-Evidence", evidence, "-Json"]
    if decision:
        args.extend(["-Decision", decision])
    if decision_maker:
        args.extend(["-DecisionMaker", decision_maker])
    if decision_rationale:
        args.extend(["-DecisionRationale", decision_rationale])
    if feature_dir:
        args.extend(["-FeatureDir", feature_dir])

    script = "gate-record.ps1" if _detect_script_type() == "ps" else "gate-record.sh"
    data = _run_gate_script(project_root, script, args)

    # Check for ordering error in the output
    gates = data.get("gates", {})
    if data.get("status") == "failed" and "prerequisite" in str(data.get("evidence", "")).lower():
        raise GateOrderError(
            f"Cannot record {gate} because prerequisite gates have not passed. "
            f"Prior gates must pass in order: {' -> '.join(GATE_ORDER)}"
        )

    return data


def get_gate_status(
    project_root: Path,
    feature_dir: Optional[str] = None,
) -> dict:
    """Read per-feature gate-status.json directly.

    Returns the parsed JSON dict, or a default skeleton with all gates
    set to 'pending' if the file doesn't exist or is corrupt.
    """
    # Resolve feature directory
    fd = feature_dir or _resolve_feature_dir(project_root)
    if fd:
        status_path = project_root / fd / "gate-status.json"
    else:
        status_path = project_root / ".specify" / "memory" / "gate-status.json"

    # Try per-feature path first, then legacy
    if not status_path.is_file() and fd:
        legacy = project_root / ".specify" / "memory" / "gate-status.json"
        if legacy.is_file():
            status_path = legacy

    if status_path.is_file():
        try:
            return json.loads(status_path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError):
            pass

    # Return default skeleton
    return {
        "ipd_mode": True,
        "feature": fd or "",
        "last_updated": "",
        "gates": {
            g: {"status": "pending", "decision": "", "evidence": "",
                "decision_maker": "", "decision_rationale": "",
                "date": "", "history": []}
            for g in GATE_ORDER
        },
    }


def enforce_gate(
    project_root: Path,
    required_gate: str,
    feature_dir: Optional[str] = None,
) -> None:
    """Hard gate enforcement — check gate and block if not passed.

    Implements the hard gate model (FR-003a). In non-IPD-mode projects
    this function returns immediately (dual-mode support).

    Raises:
        GateBlockedError: If the required gate has not passed.
    """
    if not detect_ipd_mode(project_root):
        return  # Dual-mode: skip gate checks in non-IPD projects

    try:
        check_gate(project_root, required_gate, feature_dir)
    except GateBlockedError:
        console.print()
        console.print(
            f"[bold red]❌ Gate Check Failed: {required_gate}[/bold red]"
        )
        console.print()

        # Re-raise with display handled; let caller decide exit behaviour
        raise


def require_gate(gate: str):
    """Decorator that enforces a gate check before a VIPD command executes.

    Usage::

        @app.command()
        @require_gate("TR2_TR3")
        def plan():
            ...

    In non-IPD-mode projects the check is skipped entirely.
    """
    def decorator(func):
        def wrapper(*args, **kwargs):
            project_root = Path.cwd()
            if (project_root / ".specify").is_dir():
                try:
                    enforce_gate(project_root, gate)
                except GateBlockedError as exc:
                    # Display user-friendly error
                    console.print()
                    console.print(
                        f"[bold yellow]🚫 Cannot proceed: "
                        f"Gate [red]{exc.gate}[/red] has not passed.[/bold yellow]"
                    )
                    console.print()
                    if exc.failed_criteria:
                        console.print("[bold]Failed criteria:[/bold]")
                        for c in exc.failed_criteria:
                            console.print(f"  ✗ {c}")
                    if exc.remediation:
                        console.print()
                        console.print(f"[dim]{exc.remediation}[/dim]")
                    console.print()
                    console.print(
                        "[bold]To proceed:[/bold] Complete the required "
                        "artifacts and re-run the prerequisite command, "
                        "then try again."
                    )
                    raise SystemExit(1)
                except GateScriptError as exc:
                    console.print(
                        f"[yellow]⚠ Gate script error: {exc}[/yellow]"
                    )
                    # Allow proceeding if scripts are broken
            return func(*args, **kwargs)
        wrapper.__name__ = func.__name__
        wrapper.__doc__ = func.__doc__
        return wrapper
    return decorator
