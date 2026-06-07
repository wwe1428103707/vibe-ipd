# Contract: Gate Enforcement Integration

**Feature**: 009-ipd-migration-gaps | **Date**: 2026-06-07

## Purpose

Defines the contract between the Python CLI layer and the gate-check/gate-record PowerShell and Bash scripts, following the SpecKit subprocess invocation pattern.

## Interface: Python → Gate Script Invocation

### `_gate_utils.py` — New Module

```python
def detect_ipd_mode(project_root: Path) -> bool:
    """Detect IPD mode by running gate-detect-ipd-mode script.

    Args:
        project_root: Absolute path to the project root.

    Returns:
        True if IPD mode is active (constitution has Gate Criteria Reference).

    Raises:
        GateScriptError: If the script fails or returns invalid JSON.
    """

def check_gate(project_root: Path, gate: str, feature_dir: str | None = None) -> GateCheckResult:
    """Run gate-check script for the specified gate.

    Args:
        project_root: Absolute path to the project root.
        gate: Gate ID to check (TR0, TR1, TR2_TR3, TR4, TR4A, TR5, TR6).
        feature_dir: Override feature directory (defaults to .specify/feature.json).

    Returns:
        GateCheckResult with status, prior_gates, current_gate, and errors.

    Raises:
        GateScriptError: If the script fails or returns invalid JSON.
        GateBlockedError: If the gate check fails (hard gate model — caller must halt).
    """

def record_gate(project_root: Path, gate: str, status: str, evidence: str, feature_dir: str | None = None) -> GateRecordResult:
    """Run gate-record script to update gate status.

    Args:
        project_root: Absolute path to the project root.
        gate: Gate ID to record.
        status: Status value (passed, pending, failed, hold, recycled).
        evidence: Evidence text (max 2000 chars).
        feature_dir: Override feature directory.

    Returns:
        GateRecordResult with confirmed status and date.

    Raises:
        GateOrderError: If recording is out of order (e.g., TR4 before TR1).
        GateScriptError: If the script fails or returns invalid JSON.
    """

def get_gate_status(project_root: Path, feature_dir: str | None = None) -> dict:
    """Read per-feature gate-status.json.

    Args:
        project_root: Absolute path to the project root.
        feature_dir: Override feature directory.

    Returns:
        Parsed gate-status.json dict, or empty default if file doesn't exist.
    """

def enforce_gate(project_root: Path, required_gate: str, feature_dir: str | None = None) -> None:
    """Hard gate enforcement — check gate and block if not passed.

    Args:
        project_root: Project root path.
        required_gate: The minimum gate that must be passed.
        feature_dir: Override feature directory.

    Raises:
        GateBlockedError: If the required gate has not passed. Error message
            includes which gate failed, which criteria were not met, and
            remediation guidance.

    Note:
        This implements the hard gate model (FR-003a). There is no bypass.
        The error message is user-friendly and suggests specific actions.
    """
```

### Exception Hierarchy

```python
class GateError(Exception):
    """Base exception for gate operations."""

class GateBlockedError(GateError):
    """Raised when a hard gate check fails.
    Attributes:
        gate: The gate ID that failed.
        failed_criteria: List of Must-Meet criteria that were not met.
        remediation: Suggested actions to pass the gate.
    """

class GateOrderError(GateError):
    """Raised when gate recording is attempted out of order."""

class GateScriptError(GateError):
    """Raised when a gate script fails to execute or returns invalid JSON."""
```

### Subprocess Invocation Pattern

Following the SpecKit ShellStep pattern:

```python
import subprocess
from pathlib import Path

def _run_gate_script(project_root: Path, script_name: str, args: list[str]) -> dict:
    """Run a gate script via subprocess and parse JSON output.

    Args:
        project_root: Project root for cwd.
        script_name: Script filename (e.g., "gate-check.ps1").
        args: Arguments to pass to the script.

    Returns:
        Parsed JSON output from the script.

    Raises:
        GateScriptError: On non-zero exit code or invalid JSON.
    """
    script_type = _detect_script_type()  # "ps" or "sh"
    variant_dir = "powershell" if script_type == "ps" else "bash"
    script_path = project_root / ".specify" / "scripts" / variant_dir / script_name

    if script_type == "ps":
        cmd = ["pwsh", "-File", str(script_path)] + args
    else:
        cmd = [str(script_path)] + args

    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        cwd=str(project_root),
        timeout=30,  # Gate scripts should complete in <5 seconds
    )

    if result.returncode != 0:
        raise GateScriptError(
            f"Gate script {script_name} exited with code {result.returncode}: {result.stderr}"
        )

    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError as e:
        raise GateScriptError(f"Gate script {script_name} returned invalid JSON: {e}")
```

## Interface: Command-Level Gate Enforcement

### Decorator Pattern for `vipd-*` Commands

```python
def require_gate(gate: str):
    """Decorator that enforces a gate check before a VIPD command executes.

    Usage:
        @app.command()
        @require_gate("TR2_TR3")
        def plan():
            ...

    Behavior:
        1. Detects IPD mode. If not active, proceeds without gate check.
        2. If IPD mode is active, calls enforce_gate(required_gate=gate).
        3. If enforce_gate raises GateBlockedError, prints the error message
           with remediation guidance and exits with code 1.
        4. If enforce_gate succeeds, proceeds to the command.
    """
```

### Command-to-Gate Mapping

| Command | Required Gate | FR |
|---------|---------------|-----|
| `vipd-plan` | TR1 | FR-004 |
| `vipd-checklist` | TR1 | FR-004 |
| `vipd-tasks` | TR2_TR3 | FR-004 |
| `vipd-implement` | TR4 | FR-004 |
| `vipd-analyze` | TR5 | FR-004 |
| `vipd-taskstoissues` | TR4 | FR-022 |
| `vipd-specify` | TR0 | (existing) |
| `vipd-clarify` | TR1 | (existing) |
| `vipd-constitution` | — | (no gate) |

## Interface: `specify check --gate-status` Command Extension

```python
@app.command()
def check(gate_status: bool = typer.Option(False, "--gate-status", help="Show gate status for the current feature")):
    """Check that all required tools are installed and optionally show gate status."""
    # ... existing tool checks ...

    if gate_status:
        enforce_gate._display_gate_status(project_root)
```

### Gate Status Display Output

```
IPD Gate Status: specs/009-ipd-migration-gaps

  TR0    ✅ passed   2026-06-06  Constitution ratified with Gate Criteria Reference section
  TR1    ✅ passed   2026-06-07  Spec created with TR Gate Assessment
  TR2_TR3 ✅ passed   2026-06-06  Plan created with Gate Readiness + ADL
  TR4    ✅ passed   2026-06-06  Tasks generated with Gate Completion Verification
  TR4A   ✅ passed   2026-06-06  Quality summary: 298 speckit refs renamed
  TR5    ✅ passed   2026-06-06  TR5 validation complete
  TR6    ⏳ pending  —           Launch gate not yet evaluated

  Overall: Feature can proceed to Launch phase (TR6 pending)

⚠ Advisory: Should-Meet criteria not assessed for TR1 (Market attractiveness > 8/10)
```

## Error Messages (User-Facing)

### Gate Blocked Error

```
❌ Gate Check Failed: TR2_TR3 (Plan Gate)

The following Must-Meet criteria were not satisfied:
  ✗ Plan must contain "Gate Readiness" section
  ✗ Plan must contain architecture decisions or data model

To proceed:
  1. Run /vipd-speckit-plan to create the implementation plan
  2. Ensure the plan includes Gate Readiness and Architecture Design sections
  3. Re-run this command after the gate check passes

Feature: 009-ipd-migration-gaps
Current gate status: TR0 ✅, TR1 ✅, TR2_TR3 ✗, TR4 ⏳
```

### Out-of-Order Recording Error

```
❌ Gate Order Error: Cannot record TR4 as "passed" because TR1 has not been recorded.

Prior gates that must pass first: TR0 (passed ✅), TR1 (pending ⏳)

Please run /vipd-speckit-specify and /vipd-speckit-clarify to complete the concept phase,
then record TR1 passage before proceeding to the development phase.
```