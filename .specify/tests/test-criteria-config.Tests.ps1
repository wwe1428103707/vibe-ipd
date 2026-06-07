# test-criteria-config.Tests.ps1 — Gate criteria configuration validation tests
# US2: Explicit Gate Dependency Mapping
BeforeAll {
    . "$PSScriptRoot/_test_helpers.ps1"
}

Describe 'tr-criteria.yml configuration validation' {
    It 'US2-T012: All criteria have valid owning_phase values' {
        # Arrange
        . $Script:GateHelpersPath
        $criteria = Get-GateCriteria -ConfigPath $Script:TrCriteriaPath

        # Assert
        $criteria | Should -Not -BeNullOrEmpty
        $validPhases = @('Plan', 'Task', 'Implementation')

        foreach ($c in $criteria) {
            $c.owning_phase | Should -BeIn $validPhases
        }
    }

    It 'US2-T013: No cross-phase dependency violations in depends_on' {
        # Arrange
        . $Script:GateHelpersPath
        $criteria = Get-GateCriteria -ConfigPath $Script:TrCriteriaPath

        # Build phase map
        $phaseMap = @{}
        foreach ($c in $criteria) {
            $phaseMap[$c.id] = $c.owning_phase
        }

        # Assert: no depends_on crosses phases
        $violations = @()
        foreach ($c in $criteria) {
            $deps = if ($c.depends_on) { @($c.depends_on) } else { @() }
            foreach ($dep in $deps) {
                if ($dep -and $phaseMap.ContainsKey($dep)) {
                    if ($phaseMap[$dep] -ne $c.owning_phase) {
                        $violations += "$($c.id) -> $dep"
                    }
                }
            }
        }
        $violations | Should -BeNullOrEmpty
    }
}
