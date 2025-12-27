#requires -modules InvokeBuild

<#
.SYNOPSIS
    Build script (https://github.com/nightroman/Invoke-Build)

.DESCRIPTION
    This script contains the tasks for building the 'SampleModule' PowerShell module
#>

param (
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('Debug', 'Release', 'Prerelease')]
    [String]
    $ReleaseType = 'Debug',

    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $SemanticVersion,

    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $NugetApiKey
)

# Enforce strict mode for better scripting practices
Set-StrictMode -Version Latest

# Synopsis: Default task
task . Clean, Build


# Install build dependencies
Enter-Build {
    # Setting build script variables
    $script:moduleName = 'PSScriptModule'
    $script:moduleSourcePath = Join-Path -Path $BuildRoot -ChildPath 'src'
    $script:moduleManifestPath = Join-Path -Path $moduleSourcePath -ChildPath "$moduleName.psd1"
    $script:testSourcePath = Join-Path -Path $BuildRoot -ChildPath 'tests'
    $script:testOutputPath = Join-Path -Path $BuildRoot -ChildPath 'test-results'
    $script:nuspecPath = Join-Path -Path $moduleSourcePath -ChildPath "$moduleName.nuspec"
    $script:buildOutputPath = Join-Path -Path $BuildRoot -ChildPath 'build'
    $script:publishSourcePath = Join-Path -Path $buildOutputPath -ChildPath $moduleName
    $script:coverageOutputPath = Join-Path -Path $BuildRoot -ChildPath 'coverage'
    $script:psScriptAnalyzerSourcePath = Join-Path -Path $BuildRoot -ChildPath './tests/SCA/PSScriptAnalyzer.Tests.ps1'
    $script:psScriptAnalyzerOutputPath = Join-Path -Path $testOutputPath -ChildPath 'SCA'
    $script:unitTestSourcePath = Join-Path -Path $BuildRoot -ChildPath './tests/Unit'
    $script:unitTestOutputPath = Join-Path -Path $testOutputPath -ChildPath 'Unit'


    # Setting base module version and using it if building locally
    $script:newModuleVersion = New-Object -TypeName 'System.Version' -ArgumentList (0, 0, 1)
}

# Synopsis: Analyze the project with PSScriptAnalyzer
task Analyze {
    # Create build output folder
    if (-not (Test-Path $psScriptAnalyzerOutputPath))
    {
        Write-Warning "Creating build output folder at '$psScriptAnalyzerOutputPath'"
        [void] (New-Item -Path $psScriptAnalyzerOutputPath -ItemType Directory)
    }
    $Config = New-PesterConfiguration @{
        Run        = @{
            Path = $script:psScriptAnalyzerSourcePath
            Exit = $true
        }
        TestResult = @{
            Enabled      = $true
            OutputFormat = 'NUnitXml'
            OutputPath   = "$psScriptAnalyzerOutputPath\PSSA.xml"
        }
    }

    #$Timestamp = Get-date -UFormat "%Y%m%d-%H%M%S"
    #$PSVersion = $PSVersionTable.PSVersion.Major
    #$TestResultFile = "AnalysisResults_PS$PSVersion`_$TimeStamp.xml"

    # Invoke all tests
    Invoke-Pester -Configuration $Config
}

# Synopsis: Run Pester tests Unit tests and generate code coverage report
task UnitTest {
    #$files = Get-ChildItem -Path $moduleSourcePath -Recurse -Force -Include '*.ps1' -Exclude '*.Tests.ps1', '*build.ps1'
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
            OutputPath   = "$unitTestOutputPath\testResults.xml"
        }
        CodeCoverage = @{
            Enabled        = $true
            Path           = $Script:moduleSourcePath
            OutputFormat   = 'Cobertura'
            OutputPath     = "$coverageOutputPath\coverage.xml"
            OutputEncoding = 'UTF8'
        }
    }
    # Invoke all tests
    Invoke-Pester -Configuration $unitConfig -Verbose
}

# Build the project
task Build Clean, {
    # Warning on local builds
    if ($ReleaseType -ne 'Release')
    {
        Write-Warning 'THIS IS A DEBUG BUILD. THE MODULE IS NOT SUITABLE FOR PRODUCTION USE.'
    }

    # Create build output folder
    if (-not (Test-Path $buildOutputPath))
    {
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

# Publish the module to PSGallery
task Publish -If ($NugetApiKey) {
    $requestParam = @{
        Path        = $publishSourcePath
        NuGetApiKey = $NugetApiKey
        ErrorAction = 'Stop'
    }
    [void] (Publish-Module @requestParam)
}

# Clean up the target build directory
task Clean {
    if (Test-Path $buildOutputPath)
    {
        Write-Warning "Removing build output folder at '$buildOutputPath'"
        $requestParam = @{
            Path    = $buildOutputPath
            Recurse = $true
            Force   = $true
        }
        [void] (Remove-Item @requestParam)
    }
}
