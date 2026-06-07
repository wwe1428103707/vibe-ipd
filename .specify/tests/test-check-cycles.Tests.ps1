# test-check-cycles.Tests.ps1 — Cycle detection tests
# US4: Automated Detection of Circular Gate Dependencies
BeforeAll {
    . "$PSScriptRoot/_test_helpers.ps1"
}

Describe 'Cycle detection' {
    It 'US4-T021: Detects artificially introduced circular dependencies' {
        # Arrange — create criteria with a cycle: A -> B -> C -> A
        $criteriaWithCycle = @(
            @{ id = 'TR2-MM-001'; gate = 'TR2/TR3'; type = 'Must-Meet'; title = 'A'; owning_phase = 'Plan'; depends_on = @('TR2-MM-002') }
            @{ id = 'TR2-MM-002'; gate = 'TR2/TR3'; type = 'Must-Meet'; title = 'B'; owning_phase = 'Plan'; depends_on = @('TR2-MM-003') }
            @{ id = 'TR2-MM-003'; gate = 'TR2/TR3'; type = 'Must-Meet'; title = 'C'; owning_phase = 'Plan'; depends_on = @('TR2-MM-001') }  # cycle!
        )

        # We need to source gate-check.ps1 functions — use direct PowerShell
        $script = Get-Content $Script:GateCheckPath -Raw
        # Extract the Test-CyclicDependency function
        $match = [regex]::Match($script, '(?s)function Test-CyclicDependency\s*\{(.*?)\n\}')
        if ($match.Success) {
            $funcBody = $match.Value
            & {
                . ([scriptblock]::Create($funcBody))
                $result = Test-CyclicDependency -Criteria $criteriaWithCycle

                # Assert
                $result.HasCycles | Should -Be $true
                $result.Cycles.Count | Should -BeGreaterThan 0
            }
        }
    }

    It 'US4-T022: Acyclic criteria set returns no cycles' {
        # Arrange — create criteria WITHOUT cycles
        $acyclicCriteria = @(
            @{ id = 'TR2-MM-001'; gate = 'TR2/TR3'; type = 'Must-Meet'; title = 'A'; owning_phase = 'Plan'; depends_on = @() }
            @{ id = 'TR2-MM-002'; gate = 'TR2/TR3'; type = 'Must-Meet'; title = 'B'; owning_phase = 'Plan'; depends_on = @('TR2-MM-001') }
            @{ id = 'TR2-SM-001'; gate = 'TR2/TR3'; type = 'Should-Meet'; title = 'C'; owning_phase = 'Task'; depends_on = @('TR2-MM-001') }
        )

        $script = Get-Content $Script:GateCheckPath -Raw
        $match = [regex]::Match($script, '(?s)function Test-CyclicDependency\s*\{(.*?)\n\}')
        if ($match.Success) {
            $funcBody = $match.Value
            & {
                . ([scriptblock]::Create($funcBody))
                $result = Test-CyclicDependency -Criteria $acyclicCriteria

                # Assert
                $result.HasCycles | Should -Be $false
            }
        }
    }
}
