#requires -modules InvokeBuild

<#
.SYNOPSIS
    Build script (https://github.com/nightroman/Invoke-Build)

.DESCRIPTION
    This script contains the tasks for building the 'SampleModule' PowerShell module
#>
[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '',
    Justification = 'Suppress false positives in Invoke-Build tasks')]
param (
    [Parameter()]
    [ValidateSet('Debug', 'Release', 'Prerelease')]
    [String]
    $ReleaseType = 'Debug',

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $SemanticVersion,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $NugetApiKey
)

# Enforce strict mode for better scripting practices
Set-StrictMode -Version Latest

# Synopsis: Default task
task . Clean, Build


# Setup build environment
Enter-Build {
    $script:moduleName = 'PSScriptModule'
    $script:moduleSourcePath = Join-Path -Path $BuildRoot -ChildPath 'src'
    $script:testSourcePath = Join-Path -Path $BuildRoot -ChildPath 'tests'
    $script:testOutputPath = Join-Path -Path $BuildRoot -ChildPath 'test-results'
    $script:buildOutputPath = Join-Path -Path $BuildRoot -ChildPath 'build'
    $script:publishSourcePath = Join-Path -Path $buildOutputPath -ChildPath $moduleName
}

# Synopsis: Analyze the project with PSScriptAnalyzer
task Analyze {
    # Create test output folder
    if (-not (Test-Path $testOutputPath)) {
        [void] (New-Item -Path $testOutputPath -ItemType Directory)
    }
    $Config = New-PesterConfiguration @{
        Run        = @{
            Path = (Join-Path -Path $testSourcePath -ChildPath 'PSScriptAnalyzer')
            Exit = $true
        }
        TestResult = @{
            Enabled      = $true
            OutputFormat = 'NUnitXml'
            OutputPath   = "$testOutputPath\static-code-analysis.xml"
        }
    }

    # Invoke all tests
    Invoke-Pester -Configuration $Config
}

# Synopsis: Run Pester tests Unit tests and generate code coverage report
task UnitTest {
    # Create test output folder
    if (-not (Test-Path $testOutputPath)) {
        [void] (New-Item -Path $testOutputPath -ItemType Directory)
    }

    $unitContainer = New-PesterContainer -Path $Script:moduleSourcePath -Data @{ SourcePath = $script:moduleSourcePath }
    $unitConfig = New-PesterConfiguration @{
        Run          = @{
            Container = $unitContainer
            PassThru  = $true
            Exit      = $true
        }
        TestResult   = @{
            Enabled      = $true
            OutputFormat = 'NUnitXml'
            OutputPath   = "$testOutputPath\unit-tests.xml"
        }
        CodeCoverage = @{
            Enabled        = $true
            Path           = $Script:moduleSourcePath
            OutputFormat   = 'Cobertura'
            OutputPath     = "$testOutputPath\code-coverage.xml"
            OutputEncoding = 'UTF8'
        }
    }
    # Invoke all tests
    Invoke-Pester -Configuration $unitConfig -Verbose
}

# Synopsis: Build the project
task Build Clean, {
    # Warning on local builds
    if ($ReleaseType -ne 'Release') {
        Write-Warning 'THIS IS A DEBUG BUILD. THE MODULE IS NOT SUITABLE FOR PRODUCTION USE.'
    }

    # Create build output folder
    if (-not (Test-Path $buildOutputPath)) {
        Write-Warning "Creating build output folder at '$buildOutputPath'"
        [void] (New-Item -Path $buildOutputPath -ItemType Directory)
    }

    # Copy-Item parameters
    Import-Module ModuleBuilder -ErrorAction Stop
    $requestParam = @{
        Path                       = $BuildRoot
        OutputDirectory            = $buildOutputPath
        SemVer                     = $SemanticVersion
        UnversionedOutputDirectory = $true
        ErrorAction                = 'Stop'
    }
    [void] (Build-Module @requestParam)
}

# Synopsis: Publish the module to PSGallery
task Publish -If ($NugetApiKey) {
    $requestParam = @{
        Path        = $publishSourcePath
        NuGetApiKey = $NugetApiKey
        ErrorAction = 'Stop'
    }
    [void] (Publish-Module @requestParam)
}

# Synopsis: Clean up the target build directory
task Clean {
    if (Test-Path $buildOutputPath) {
        Write-Warning "Removing build output folder at '$buildOutputPath'"
        $requestParam = @{
            Path    = $buildOutputPath
            Recurse = $true
            Force   = $true
        }
        [void] (Remove-Item @requestParam)
    }
}
