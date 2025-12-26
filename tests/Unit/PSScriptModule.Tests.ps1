# Generate Pester Unit tests for the module
[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '',
    Justification = 'Suppress false positives in Pester code blocks')]
param(
    [System.IO.DirectoryInfo]
    $SourcePath
)

BeforeAll {
    $publicPath = Join-Path -Path $SourcePath -ChildPath 'Public'
    $privatePath = Join-Path -Path $SourcePath -ChildPath 'Private'
    
}
BeforeDiscovery {
    if (-not (Test-Path -Path $SourcePath)) {
        throw "Source path '$SourcePath' does not exist."
    }
}

Describe "PSScriptModule Unit Tests" {

    It "Have at least 1 Public Function <_>" -Foreach ($SourcePath) {
        $publicFunctions = Get-ChildItem -Path $publicPath
        $publicPath | Should -Be 'tests/Unit/Public'
        $publicFunctions.Count | Should -BeGreaterThan 0
    }

    It "Have at least 1 Private Function <_>" -Foreach ($SourcePath) {
        $privateFunctions = Get-ChildItem -Path $privatePath
        $privateFunctions.Count | Should -BeGreaterThan 0
    }
}