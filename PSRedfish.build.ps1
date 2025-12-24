#requires -modules InvokeBuild

<#
.SYNOPSIS
    Build script (https://github.com/nightroman/Invoke-Build)

.DESCRIPTION
    This script contains the tasks for building the 'SampleModule' PowerShell module
#>

Param (
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [ValidateSet('Debug', 'Release')]
    [String]
    $Configuration = 'Debug',
    [Parameter(ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [String]
    $SourceLocation
)

Set-StrictMode -Version Latest

# Synopsis: Default task
task . Clean, Build


# Install build dependencies
Enter-Build {

    # Installing PSDepend for dependency management
    if (-not (Get-Module -Name PSDepend -ListAvailable)) {
        Install-Module PSDepend -Force
    }
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
    $script:coverageOutputPath = Join-Path -Path $buildOutputPath -ChildPath 'coverage'

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

# Synopsis: Test the project with Pester tests
task Test {
    $TestFiles = Get-ChildItem -Path $script:testSourcePath -Recurse -Include "*.Tests.*"
    
    $Config = New-PesterConfiguration @{
        Run          = @{
            Path = $TestFiles
            Exit = $true
        }
        TestResult   = @{
            Enabled      = $true
            OutputFormat = 'NUnitXml'
            OutputPath   = "$coverageOutputPath\testResults.xml"
        }
        CodeCoverage = @{
            Enabled      = $true
            OutputFormat = 'Cobertura'
            OutputPath   = "$coverageOutputPath\coverage.xml"
        }
    }

    # Invoke all tests
    Invoke-Pester -Configuration $Config -Verbose
}

# Synopsis: Generate a new module version if creating a release build
task GenerateNewModuleVersion -If ($Configuration -eq 'Release') {
    # Using the current NuGet package version from the feed as a version base when building via Azure DevOps pipeline

    # Define package repository name
    $repositoryName = $moduleName + '-repository'

    # Register a target PSRepository
    try {
        Register-PSRepository -Name $repositoryName -SourceLocation $SourceLocation -InstallationPolicy Trusted
    }
    catch {
        throw "Cannot register '$repositoryName' repository with source location '$SourceLocation'!"
    }

    # Define variable for existing package
    $existingPackage = $null

    try {
        # Look for the module package in the repository
        $existingPackage = Find-Module -Name $moduleName -Repository $repositoryName
    }
    # In no existing module package was found, the base module version defined in the script will be used
    catch {
        Write-Warning "No existing package for '$moduleName' module was found in '$repositoryName' repository!"
    }

    # If existing module package was found, try to install the module
    if ($existingPackage) {
        # Get the largest module version
        # $currentModuleVersion = (Get-Module -Name $moduleName -ListAvailable | Measure-Object -Property 'Version' -Maximum).Maximum
        $currentModuleVersion = New-Object -TypeName 'System.Version' -ArgumentList ($existingPackage.Version)

        # Set module version base numbers
        [int]$Major = $currentModuleVersion.Major
        [int]$Minor = $currentModuleVersion.Minor
        [int]$Build = $currentModuleVersion.Build

        try {
            # Install the existing module from the repository
            Install-Module -Name $moduleName -Repository $repositoryName -RequiredVersion $existingPackage.Version
        }
        catch {
            throw "Cannot import module '$moduleName'!"
        }

        # Get the count of exported module functions
        $existingFunctionsCount = (Get-Command -Module $moduleName | Where-Object -Property Version -EQ $existingPackage.Version | Measure-Object).Count
        # Check if new public functions were added in the current build
        [int]$sourceFunctionsCount = (Get-ChildItem -Path "$moduleSourcePath\Public\*.ps1" -Exclude "*.Tests.*" | Measure-Object).Count
        [int]$newFunctionsCount = [System.Math]::Abs($sourceFunctionsCount - $existingFunctionsCount)

        # Increase the minor number if any new public functions have been added
        if ($newFunctionsCount -gt 0) {
            [int]$Minor = $Minor + 1
            [int]$Build = 0
        }
        # If not, just increase the build number
        else {
            [int]$Build = $Build + 1
        }

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
    if ($Configuration -eq 'Debug') {
        Write-Warning "Creating a debug build. Use it for test purpose only!!!"
    }

    # Create versioned output folder
    if (-not (Test-Path $buildOutputPath)) {
        Write-Warning "Creating build output folder at '$buildOutputPath'"
        [void] (New-Item -Path $buildOutputPath -ItemType Directory)
    }

    # Copy-Item parameters
    Import-Module ModuleBuilder -ErrorAction Stop
    Build-Module -Path $moduleSourcePath -OutputDirectory $buildOutputPath -ErrorAction Stop
}

# Synopsis: Verify the code coverage by tests
task CodeCoverage {
    $files = Get-ChildItem $moduleSourcePath -Dir -Force -Recurse |
    Where-Object { $_.FullName -notLike '*build*' -and $_.FullName -notLike '*.git*' } |
    Get-ChildItem -File -Force -Include '*.ps1' -Exclude '*.Tests.ps1' |
    Select-Object -ExpandProperty FullName

    $Config = New-PesterConfiguration @{
        Run          = @{
            Path     = $moduleSourcePath
            PassThru = $true
        }
        Output       = @{
            Verbosity = 'Normal'
        }
        CodeCoverage = @{
            Enabled               = $true
            Path                  = $files
            CoveragePercentTarget = 60
        }
    }

    # Additional parameters on Azure Pipelines agents to generate code coverage report
    if ($env:TF_BUILD) {
        if (-not (Test-Path -Path $buildOutputPath -ErrorAction SilentlyContinue)) {
            New-Item -Path $buildOutputPath -ItemType Directory
        }
        $Timestamp = Get-date -UFormat "%Y%m%d-%H%M%S"
        $PSVersion = $PSVersionTable.PSVersion.Major
        $TestResultFile = "CodeCoverageResults_PS$PSVersion`_$TimeStamp.xml"
        $Config.CodeCoverage.OutputPath = "$buildOutputPath\$TestResultFile"
    }

    $result = Invoke-Pester -Configuration $config

    # Fail the task if the code coverage results are not acceptable
    if ( $result.CodeCoverage.CoveragePercent -lt $result.CodeCoverage.CoveragePercentTarget) {
        throw "The overall code coverage by Pester tests is $("0:0.##" -f $result.CodeCoverage.CoveragePercent)% which is less than quality gate of $($result.CodeCoverage.CoveragePercentTarget)%. Pester ModuleVersion is: $((Get-Module -Name Pester -ListAvailable).ModuleVersion)."
    }
}

# Synopsis: Clean up the target build directory
task Clean {
    if (Test-Path $buildOutputPath) {
        Remove-Item -Path $buildOutputPath -Recurse
    }
}
