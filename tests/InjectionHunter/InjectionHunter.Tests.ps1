[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '',
    Justification = 'Suppress false positives in Pester code blocks')]
param()


Describe 'Injection Hunter security checks' {

    BeforeAll {
        $injectionHunterPath = (Get-Module InjectionHunter -ListAvailable).Path
    }
    BeforeDiscovery {
        $modulePath = Resolve-Path (Join-Path $PSScriptRoot '..\..\src')
        $files = Get-ChildItem -Path $modulePath -Recurse -Include '*.ps*1' -Exclude '*.Tests.*'
    }

    It '<_.BaseName> contains no Injection Hunter violations' -ForEach $files {
        $requestParam = @{
            Path           = $_
            Recurse        = $true
            CustomRulePath = $injectionHunterPath
            Severity       = 'Warning', 'Error'
        }
        $results = Invoke-ScriptAnalyzer @requestParam | ForEach-Object {
            "Problem in $($_.ScriptName) at line $($_.Line) with message: $($_.Message)"
        }

        $results | Should -BeNullOrEmpty
    }
}
