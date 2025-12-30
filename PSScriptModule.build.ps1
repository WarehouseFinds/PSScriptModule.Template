#requires -modules InvokeBuild

<#
.SYNOPSIS
    Build script for the 'PSScriptModule' PowerShell module

.DESCRIPTION
    This script contains the tasks for building the 'PSScriptModule' PowerShell module
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

# Synopsis: Default task
task . Clean, Build

# Setup build environment
Enter-Build {
    $script:moduleName = 'PSScriptModule'
    $script:moduleSourcePath = Join-Path -Path $BuildRoot -ChildPath 'src'
    $script:testSourcePath = Join-Path -Path $BuildRoot -ChildPath 'tests'
    $script:testOutputPath = Join-Path -Path $BuildRoot -ChildPath 'test-results'
    $script:buildPath = Join-Path -Path $BuildRoot -ChildPath 'build'
    $script:helpPath = Join-Path -Path $BuildRoot -ChildPath 'docs/help'
}

# Synopsis: Analyze the project with PSScriptAnalyzer
task Invoke-PSScriptAnalyzer {
    if (-not (Test-Path $testOutputPath)) {
        [void] (New-Item -Path $testOutputPath -ItemType Directory)
    }
    $config = New-PesterConfiguration @{
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
    Invoke-Pester -Configuration $config
}

# Synopsis: Scan the project with Injection Hunter
task Invoke-InjectionHunter {

    $config = New-PesterConfiguration @{
        Run        = @{
            Path = (Join-Path -Path $testSourcePath -ChildPath 'InjectionHunter')
            Exit = $true
        }
        TestResult = @{
            Enabled      = $true
            OutputFormat = 'NUnitXml'
            OutputPath   = "$testOutputPath\code-injection.xml"
        }
    }

    Invoke-Pester -Configuration $config
}

# Synopsis: Run unit tests and generate code coverage report
task Invoke-UnitTests {

    $container = New-PesterContainer -Path $Script:moduleSourcePath -Data @{ SourcePath = $script:moduleSourcePath }
    $config = New-PesterConfiguration @{
        Run          = @{
            Container = $container
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
    Invoke-Pester -Configuration $config -Verbose
}

# Synopsis: Run all tests
task Test Invoke-UnitTests, Invoke-PSScriptAnalyzer, Invoke-InjectionHunter

# Synopsis: Generate module help documentation
task Export-CommandHelp {

    # Import the module being built and PlatyPS module
    [void] (Import-Module (Join-Path -Path $buildPath -ChildPath "out/$moduleName/$moduleName.psd1") -Force)
    [void] (Import-Module 'Microsoft.PowerShell.PlatyPS')

    # Generate markdown help files
    $requestParam = @{
        CommandInfo    = (Get-Command -Module $moduleName)
        OutputFolder   = "$buildPath/help"
        HelpVersion    = $SemanticVersion
        WithModulePage = $true
        Force          = $true
    }
    [void] (New-MarkdownCommandHelp @requestParam)

    # Validate generated markdown help files
    $helpFiles = Measure-PlatyPSMarkdown -Path "$buildPath/help/PSScriptModule/*.md"
    foreach ($helpFile in $helpFiles) {
        [void] (Test-MarkdownCommandHelp -Path $helpFile.FilePath)
    }

    # Generate module help file
    $mdfiles = Measure-PlatyPSMarkdown -Path "$buildPath/help/PSScriptModule/*.md" | Where-Object Filetype -Match 'CommandHelp'
    foreach ($mdfile in $mdfiles) {
        $markdownCommandHelp = Import-MarkdownCommandHelp -Path $mdfile.FilePath
        $requestParam = @{
            CommandHelp  = $markdownCommandHelp
            OutputFolder = (Join-Path -Path $buildPath -ChildPath "out/$moduleName/en-US")
            Force        = $true
        }
        [void] (Export-MamlCommandHelp @requestParam)
    }

    # Copy generated command help files to docs/help
    if (Test-Path $helpPath) {
        [void] (Remove-Item -Path $helpPath -Recurse -Force)
    }
    [void] (New-Item -Path $helpPath -ItemType Directory -Force)
    [void] ($mdfiles | ForEach-Object { Copy-Item -Path $_.FilePath -Destination $helpPath -Force })
}

# Synopsis: Build the project
task Build Clean, {

    # Copy src directory to ./build folder
    $requestParam = @{
        Destination = (Join-Path -Path $buildPath -ChildPath 'src')
        Path        = $Script:moduleSourcePath
        Container   = $true
        Recurse     = $true
        Force       = $true
    }
    [void] (Copy-Item @requestParam)

    # Remove tests files if present (*.Tests.ps1)
    $requestParam = @{
        Path    = (Join-Path -Path $buildPath -ChildPath 'src')
        Filter  = '*.Tests.ps1'
        Recurse = $true
        File    = $true
    }
    [void] (Get-ChildItem @requestParam | Remove-Item -Force)

    # Build Powershell module
    Import-Module ModuleBuilder -ErrorAction Stop
    $requestParam = @{
        Path                       = (Join-Path -Path $buildPath -ChildPath "src/$moduleName.psd1")
        OutputDirectory            = (Join-Path -Path $buildPath -ChildPath "out/$moduleName")
        SemVer                     = $SemanticVersion
        UnversionedOutputDirectory = $true
        ErrorAction                = 'Stop'
    }
    [void] (Build-Module @requestParam)
}

# Synopsis: Publish the module to PSGallery
task Publish -If ($NugetApiKey) {
    $requestParam = @{
        Path        = (Join-Path -Path $buildPath -ChildPath "out/$moduleName")
        NuGetApiKey = $NugetApiKey
        ErrorAction = 'Stop'
    }
    [void] (Publish-Module @requestParam)
}

# Synopsis: Clean up the target build directory
task Clean {
    if (Test-Path $buildPath) {
        Write-Warning "Removing build output folder at '$buildPath'"
        $requestParam = @{
            Path    = $buildPath
            Recurse = $true
            Force   = $true
        }
        [void] (Remove-Item @requestParam)
    }
}
