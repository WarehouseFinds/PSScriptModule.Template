#requires -modules InvokeBuild

<#
.SYNOPSIS
    Build script (https://github.com/nightroman/Invoke-Build)

.DESCRIPTION
    This script contains the tasks for building the 'SampleModule' PowerShell module
#>

[CmdletBinding(DefaultParameterSetName = 'Debug')]
Param (
    [Parameter(Mandatory = $true, ParameterSetName = 'Debug', ValueFromPipelineByPropertyName = $true)]
    [Parameter(Mandatory = $true, ParameterSetName = 'Release', ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('Debug', 'Release')]
    [String]
    $ReleaseType = 'Debug',

    [Parameter(Mandatory = $true, ParameterSetName = 'Release', ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $SemanticVersion
)

Set-StrictMode -Version Latest

# Synopsis: Default task
task . Clean, Build


# Install build dependencies
Enter-Build {

    # Installing PSDepend for dependency management
    Import-Module PSDepend

    # Installing dependencies
    Invoke-PSDepend -Force

    # Setting build script variables
    $script:moduleName = 'PSRedfishClient'
    $script:moduleSourcePath = Join-Path -Path $BuildRoot -ChildPath 'src'
    $script:moduleManifestPath = Join-Path -Path $moduleSourcePath -ChildPath "$moduleName.psd1"
    $script:testSourcePath = Join-Path -Path $BuildRoot -ChildPath 'tests'
    $script:nuspecPath = Join-Path -Path $moduleSourcePath -ChildPath "$moduleName.nuspec"
    $script:buildOutputPath = Join-Path -Path $BuildRoot -ChildPath 'build'
    $script:coverageOutputPath = Join-Path -Path $BuildRoot -ChildPath 'coverage'

    # Setting base module version and using it if building locally
    $script:newModuleVersion = New-Object -TypeName 'System.Version' -ArgumentList (0, 0, 1)
}

# Synopsis: Analyze the project with PSScriptAnalyzer
task Analyze {
    # Get-ChildItem parameters
    $TestFiles = Get-ChildItem -Path $moduleSourcePath -Recurse -Include "*.PSSATests.*"
    
    $Config = New-PesterConfiguration @{
        Run        = @{
            Path = $TestFiles
            Exit = $true
        }
        TestResult = @{
            Enabled = $true
        }
    }

    # Additional parameters on Azure Pipelines agents to generate test results
    if ($env:TF_BUILD) {
        if (-not (Test-Path -Path $buildOutputPath -ErrorAction SilentlyContinue)) {
            New-Item -Path $buildOutputPath -ItemType Directory
        }
        $Timestamp = Get-date -UFormat "%Y%m%d-%H%M%S"
        $PSVersion = $PSVersionTable.PSVersion.Major
        $TestResultFile = "AnalysisResults_PS$PSVersion`_$TimeStamp.xml"
        $Config.TestResult.OutputPath = "$buildOutputPath\$TestResultFile"
    }

    # Invoke all tests
    Invoke-Pester -Configuration $Config
}

# Synopsis: Run Pester tests Unit tests and generate code coverage report
task UnitTest {
    #$files = Get-ChildItem -Path $moduleSourcePath -Recurse -Force -Include '*.ps1' -Exclude '*.Tests.ps1', '*build.ps1'
    
    $Config = New-PesterConfiguration @{
        Run          = @{
            Path     = $Script:testSourcePath
            PassThru = $true
            Exit     = $true
        }
        TestResult   = @{
            Enabled      = $true
            OutputFormat = 'NUnitXml'
            OutputPath   = "$coverageOutputPath\testResults.xml"
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
    $result = Invoke-Pester -Configuration $Config -Verbose

    # Fail the task if the code coverage results are not acceptable
    if ( $result.CodeCoverage.CoveragePercent -lt $result.CodeCoverage.CoveragePercentTarget) {
        throw "The overall code coverage by Pester tests is $("0:0.##" -f $result.CodeCoverage.CoveragePercent)% which is less than quality gate of $($result.CodeCoverage.CoveragePercentTarget)%. Pester ModuleVersion is: $((Get-Module -Name Pester -ListAvailable).ModuleVersion)."
    }
}

# Generate a new module version if creating a release build
task GenerateNewModuleVersion {
    # Using the current NuGet package version from the feed as a version base when building via Azure DevOps pipeline
    $Script:moduleVersion = New-Object -TypeName 'System.Version' -ArgumentList ($SemanticVersion)
}

# Update the module manifest with module version
task UpdateModuleManifest GenerateNewModuleVersion, {
    Get-ChildItem -path $Script:moduleSourcePath
    $Params = @{
        Path          = $Script:moduleManifestPath
        ModuleVersion = $Script:moduleVersion
    }
    [void] (Update-PSModuleManifest @Params)
}

# Update the NuGet package specification with module version
task UpdatePackageSpecification GenerateNewModuleVersion, {
    $xml = New-Object -TypeName 'XML'
    $xml.Load($nuspecPath)
    $metadata = Select-XML -Xml $xml -XPath '//package/metadata'
    $metadata.Node.Version = $moduleVersion
    [void] ($xml.Save($nuspecPath))
}

# Build the project
task Build UpdateModuleManifest, UpdatePackageSpecification, {
    # Warning on local builds
    if ($ReleaseType -eq 'Debug') {
        Write-Warning "THIS IS A DEBUG BUILD. THE MODULE IS NOT SUITABLE FOR PRODUCTION USE."
    }

    # Create build output folder
    if (-not (Test-Path $buildOutputPath)) {
        Write-Warning "Creating build output folder at '$buildOutputPath'"
        [void] (New-Item -Path $buildOutputPath -ItemType Directory)
    }

    # Copy-Item parameters
    Import-Module ModuleBuilder -ErrorAction Stop
    Build-Module -Path $BuildRoot -OutputDirectory $buildOutputPath -ErrorAction Stop
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

    Write-Information "Build output folder cleaned up."
}
