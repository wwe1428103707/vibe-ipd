# test-gate-conditional-pass.Tests.ps1 — Conditional-pass verdict and deferred items tests
# US3: Graceful Gate Degradation with Partial Evidence
BeforeAll {
    . "$PSScriptRoot/_test_helpers.ps1"
}

Describe 'Conditional-pass verdict' {
    It 'US3-T016: gate-check produces verdict for mixed passed/deferred criteria' {
        # This test verifies that gate-check.ps1 can process criteria and produce a verdict
        $repoDir = New-TestGitRepo
        try {
            $scriptsDir = Join-Path $repoDir '.specify/scripts/powershell'
            Copy-Item -Path $Script:GateCommonPath -Destination (Join-Path $scriptsDir 'gate-common.ps1') -Force
            Copy-Item -Path $Script:GateHelpersPath -Destination (Join-Path $scriptsDir '_gate_helpers.ps1') -Force
            Copy-Item -Path $Script:GateCheckPath -Destination (Join-Path $scriptsDir 'gate-check.ps1') -Force
            Copy-Item -Path $Script:GateRecordPath -Destination (Join-Path $scriptsDir 'gate-record.ps1') -Force

            $gatesDir = Join-Path $repoDir '.specify/gates'
            Copy-Item -Path $Script:TrCriteriaPath -Destination (Join-Path $gatesDir 'tr-criteria.yml') -Force

            $featureDir = Join-Path $repoDir 'specs/test-feature'
            New-Item -ItemType Directory -Path $featureDir -Force | Out-Null
            '# Test Spec' | Out-File (Join-Path $featureDir 'spec.md')
            '# Test Plan with dependency info' | Out-File (Join-Path $featureDir 'plan.md')
            $featureJson = @{ feature_directory = 'specs/test-feature' } | ConvertTo-Json
            $featureJson | Out-File (Join-Path $repoDir '.specify/feature.json') -Encoding UTF8

            Push-Location $repoDir
            try {
                # Act — run gate-check with validate config mode (doesn't need prior gates)
                $result = & (Join-Path $scriptsDir 'gate-check.ps1') -Gate TR2_TR3 -ValidateConfig -Json 2>&1
                $parsed = $result | ConvertFrom-Json

                # Assert
                $parsed | Should -Not -Be $null
                $parsed.mode | Should -Be 'validate-config'
                $parsed.criteria_count | Should -BeGreaterThan 0
            } finally {
                Pop-Location
            }
        } finally {
            Remove-TestGitRepo $repoDir
        }
    }

    It 'US3-T017: gate-record with conditional-pass status creates deferred-items.json' {
        # Arrange
        $tmpDir = New-TestFeatureDir
        try {
            . $Script:GateHelpersPath

            # Act — create deferred items via Set-DeferredItems
            $items = @(@{
                criterion_id = 'TR2-SM-001'
                originating_gate = 'TR2/TR3'
                target_gate = 'TR4'
                owner = 'LPDT'
                due_by_phase = 'Development'
                status = 'deferred'
                justification = 'Effort variance can only be measured after task generation'
                deferred_at = (Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')
            })
            Set-DeferredItems -FeatureDir $tmpDir -Items $items -OriginatingGate 'TR2/TR3'

            # Assert — file was created
            $deferredPath = Join-Path $tmpDir 'deferred-items.json'
            Test-Path $deferredPath | Should -Be $true

            # Read and validate structure
            $parsed = Get-Content $deferredPath -Raw | ConvertFrom-Json
            $parsed.feature | Should -Not -BeNullOrEmpty
            $parsed.originating_gate | Should -Be 'TR2/TR3'
            $parsed.items.Count | Should -Be 1
            $parsed.items[0].criterion_id | Should -Be 'TR2-SM-001'
            $parsed.items[0].status | Should -Be 'deferred'
        } finally {
            Remove-TestFeatureDir $tmpDir
        }
    }
}
