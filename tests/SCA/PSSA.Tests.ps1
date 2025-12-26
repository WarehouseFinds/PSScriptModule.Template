[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '',
    Justification = 'Suppress false positives in Pester code blocks')]
param()

BeforeDiscovery {
    # For use within the tests, during the Run phase
    $modulePath = Resolve-Path (Join-Path $PSScriptRoot '..\..\src')

    # Dynamically defining the functions to analyze
    $functionPaths = @()
    if (Test-Path -Path "$modulePath\Private\*.ps1") {
        $functionPaths += Get-ChildItem -Path "$modulePath\Private\*.ps1" -Exclude "*.Tests.*"
    }
    if (Test-Path -Path "$modulePath\Public\*.ps1") {
        $functionPaths += Get-ChildItem -Path "$modulePath\Public\*.ps1" -Exclude "*.Tests.*"
    }
}

Describe "'<_>' Function Analysis with PSScriptAnalyzer" -ForEach $functionPaths {
    BeforeAll {
        $functionName = $_.BaseName
        $functionPath = $_
    }
    
    Context 'Standard Rules' {
        # Define PSScriptAnalyzer rules
        $scriptAnalyzerRules = Get-ScriptAnalyzerRule # Just getting all default rules

        # Perform analysis against each rule
        $scriptAnalyzerRules | ForEach-Object {
            It "should pass '<Rule>' rule" -TestCases @{ Rule = $_ } {
                Invoke-ScriptAnalyzer -Path $functionPath -IncludeRule $Rule | Should -BeNullOrEmpty
            }
        }
    }
}