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

# Synopsis: Generate a new module version if creating a release build
task GenerateNewModuleVersion -If ($ReleaseType -eq 'Release') {
    # Using the current NuGet package version from the feed as a version base when building via Azure DevOps pipeline


    # If existing module package was found, try to install the module
    if ($existingPackage) {
        # Get the largest module version
        # $currentModuleVersion = (Get-Module -Name $moduleName -ListAvailable | Measure-Object -Property 'Version' -Maximum).Maximum
        $currentModuleVersion = New-Object -TypeName 'System.Version' -ArgumentList ($existingPackage.Version)

        # Set module version base numbers
        [int]$Major = $currentModuleVersion.Major
        [int]$Minor = $currentModuleVersion.Minor
        [int]$Build = $currentModuleVersion.Build

        # Update the module version object
        $Script:newModuleVersion = New-Object -TypeName 'System.Version' -ArgumentList ($Major, $Minor, $Build)
    }
}

# Synopsis: Update the module manifest with module version and functions to export
task UpdateModuleManifest GenerateNewModuleVersion, {
    # Update-ModuleManifest parameters
    $Params = @{
        Path          = $moduleManifestPath
        ModuleVersion = $newModuleVersion
    }

    # Update the manifest file
    Update-ModuleManifest @Params
}

# Synopsis: Update the NuGet package specification with module version
task UpdatePackageSpecification GenerateNewModuleVersion, {
    # Load the specification into XML object
    $xml = New-Object -TypeName 'XML'
    $xml.Load($nuspecPath)

    # Update package version
    $metadata = Select-XML -Xml $xml -XPath '//package/metadata'
    $metadata.Node.Version = $newModuleVersion

    # Save XML object back to the specification file
    $xml.Save($nuspecPath)
}

# Synopsis: Build the project
#task Build UpdateModuleManifest, UpdatePackageSpecification, {
task Build {
    # Warning on local builds
    if ($ReleaseType -eq 'Debug') {
        Write-Warning "Creating a debug build. Use it for test purpose only!!!"
    }

    # Create versioned output folder
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
            Path   = $buildOutputPath
            Recurse = $true
            Force   = $true
        }
        [void] (Remove-Item @requestParam)
    }

    Write-Information "Build output folder cleaned up."
}
