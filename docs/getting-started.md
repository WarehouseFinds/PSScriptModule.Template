# 🚀 Getting Started

Welcome! This guide will help you set up your development environment and start building your PowerShell module.

## Prerequisites

### Required

- **PowerShell 7.0+** - Core runtime ([Download](https://github.com/PowerShell/PowerShell/releases))
- **Git** - Version control ([Download](https://git-scm.com/downloads))

### Recommended

- **Visual Studio Code** with PowerShell extension - Best development experience
- **PSDepend** - Dependency management

### Optional

- **GitHub Copilot** - AI-assisted coding
- **Docker or Rancher Desktop** - For devcontainer support
- **PowerShell Gallery account** - Required only if you plan to publish your module

## Initial Setup

### 1. Create Your Repository

Click the "Use this template" button on GitHub to create a new repository from this template.

1. **Fill in repository details**:
   - **Name**: Your module name (e.g., `MyAwesomeModule`)
   - **Description**: Brief description of your module
   - **Visibility**: Public or Private

2. **Wait for bootstrap** (~20 seconds):
   - The automated workflow renames all references from `PSScriptModule` to your module name
   - Updates the module manifest with your description
   - Removes template-specific files

3. **Refresh the page** to see your customized repository

### 2. Clone the Repository

```bash
git clone https://github.com/YourUsername/YourModuleName.git
cd YourModuleName
```

### 3. Install Dependencies

#### Option A: Using Devcontainer (Recommended)

If you have Docker/Rancher Desktop installed:

1. Open the repository in VS Code
2. When prompted, click "Reopen in Container"
3. All dependencies are pre-installed ✅

#### Option B: Local Installation

```powershell
# Install PSDepend if not already installed
Install-Module -Name PSDepend -Scope CurrentUser -Force

# Install all project dependencies
Invoke-PSDepend -Path ./requirements.psd1 -Install -Import -Force
```

This installs:

| Module | Purpose |
|--------|---------|
| **InvokeBuild** | Build orchestration |
| **ModuleBuilder** | Module compilation |
| **Pester** | Testing framework |
| **PSScriptAnalyzer** | Static code analysis |
| **InjectionHunter** | Security vulnerability scanning |
| **Microsoft.PowerShell.PlatyPS** | Help documentation generation |

### 4. Verify Installation

```powershell
# Test that build system works
Invoke-Build

# Expected output:
# Build YourModuleName 0.1.0
# Tasks: Clean, Build
# Build succeeded. 2 tasks, 0 errors, 0 warnings
```

## Project Structure

Understanding the project layout:

```plaintext
YourModuleName/
├── 📄 PSScriptModule.build.ps1      # Build script with all tasks
├── 📄 requirements.psd1             # Dependency configuration
├── 📄 GitVersion.yml                # Version management config
│
├── 📁 src/                          # Your module source code
│   ├── 📄 YourModuleName.psd1       # Module manifest (metadata)
│   ├── 📁 Public/                   # Exported functions
│   ├── 📁 Private/                  # Internal functions
│   └── 📁 Classes/                  # Class definitions
│
├── 📁 tests/                        # Quality assurance
│   ├── 📁 PSScriptAnalyzer/         # Code analysis tests
│   └── 📁 InjectionHunter/          # Security tests
│
├── 📁 docs/                         # Documentation
│   ├── 📄 getting-started.md        # This file
│   ├── 📄 development.md            # Development workflow
│   ├── 📄 ci-cd.md                  # CI/CD and publishing
│   └── 📁 help/                     # Command help (auto-generated)
│
└── 📁 build/                        # Build output (generated)
    └── 📁 out/                      # Compiled module
```

## Customizing Your Module

### 1. Update Module Manifest

Edit `src/YourModuleName.psd1`:

```powershell
@{
    # Update these fields:
    Author = 'Your Name'
    CompanyName = 'Your Company'
    Copyright = '(c) 2026 Your Name. All rights reserved.'
    Description = 'Detailed description of what your module does'
    
    # Add relevant tags for PowerShell Gallery
    Tags = @('PowerShell', 'Automation', 'DevOps')
    
    # Set your project URLs
    ProjectUri = 'https://github.com/YourUsername/YourModuleName'
    LicenseUri = 'https://github.com/YourUsername/YourModuleName/blob/main/LICENSE'
    
    # Module version (auto-updated by GitVersion)
    ModuleVersion = '0.1.0'
    
    # Functions to export (update as you add functions)
    FunctionsToExport = @('Get-PSScriptModuleInfo')
}
```

### 2. Update README Badges

In `README.md`, replace badge URLs:

```markdown
# Change this:
[![CI](https://github.com/WarehouseFinds/PSScriptModule/...)]

# To this:
[![CI](https://github.com/YourUsername/YourModuleName/...)]
```

### 3. Review License

Update `LICENSE` file with your preferred license and copyright information.

### 4. Customize CONTRIBUTING.md

Update contribution guidelines to match your project's needs.

## Quick Start Commands

```powershell
# Build the module
Invoke-Build                          # Clean + Build (default)
Invoke-Build Build                    # Build only

# Run tests
Invoke-Build Test                     # Run all tests
Invoke-Build Invoke-UnitTests         # Unit tests only

# Code quality
Invoke-Build Invoke-PSScriptAnalyzer  # Static analysis
Invoke-Build Invoke-InjectionHunter   # Security scan

# Generate documentation
Invoke-Build Export-CommandHelp       # Create help files

# Clean up
Invoke-Build Clean                    # Remove build artifacts
```

## Your First Function

Let's create a simple function:

### 1. Create Function File

Create `src/Public/Get-Greeting.ps1`:

```powershell
function Get-Greeting {
    <#
    .SYNOPSIS
        Returns a greeting message
    
    .DESCRIPTION
        Generates a personalized greeting message for the specified name.
    
    .PARAMETER Name
        The name to include in the greeting
    
    .EXAMPLE
        Get-Greeting -Name 'World'
        Returns: "Hello, World!"
    
    .OUTPUTS
        System.String
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )
    
    Write-Verbose "Generating greeting for: $Name"
    return "Hello, $Name!"
}
```

### 2. Create Test File

Create `src/Public/Get-Greeting.Tests.ps1`:

```powershell
BeforeAll {
    # Import the function being tested
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'Get-Greeting' {
    Context 'Parameter Validation' {
        It 'Should require Name parameter' {
            { Get-Greeting } | Should -Throw
        }
        
        It 'Should not accept null or empty Name' {
            { Get-Greeting -Name '' } | Should -Throw
            { Get-Greeting -Name $null } | Should -Throw
        }
    }
    
    Context 'Functionality' {
        It 'Should return greeting with provided name' {
            $result = Get-Greeting -Name 'PowerShell'
            $result | Should -Be 'Hello, PowerShell!'
        }
        
        It 'Should return string type' {
            $result = Get-Greeting -Name 'Test'
            $result | Should -BeOfType [string]
        }
    }
}
```

### 3. Update Module Manifest

Add your function to exports in `src/YourModuleName.psd1`:

```powershell
FunctionsToExport = @('Get-PSScriptModuleInfo', 'Get-Greeting')

# Or use wildcard to export all Public functions:
FunctionsToExport = '*'
```

### 4. Build and Test

```powershell
# Build the module
Invoke-Build

# Run tests
Invoke-Build Test

# Test your function
Import-Module ./build/out/YourModuleName/YourModuleName.psd1 -Force
Get-Greeting -Name 'PowerShell'
```

## Development Workflow

### Daily Development

```powershell
# 1. Pull latest changes
git pull origin main

# 2. Create feature branch
git checkout -b feature/my-new-feature

# 3. Make your changes
# - Add/modify functions in src/Public/ or src/Private/
# - Add/update corresponding .Tests.ps1 files
# - Update help documentation if needed

# 4. Run tests frequently
Invoke-Build Test

# 5. Commit with semantic versioning keyword
git commit -m "Add new feature +semver: minor"

# 6. Push and create Pull Request
git push origin feature/my-new-feature
```

### Version Control Keywords

Include these in commit messages to control version bumps:

- `+semver: major` - Breaking changes (1.0.0 → 2.0.0)
- `+semver: minor` - New features (1.0.0 → 1.1.0)
- `+semver: patch` - Bug fixes (1.0.0 → 1.0.1)
- `+semver: none` - No version change (documentation only)

## Troubleshooting

### Build Failures

**Problem**: `Invoke-Build` not found

```powershell
# Solution: Install InvokeBuild
Install-Module -Name InvokeBuild -Scope CurrentUser -Force
```

**Problem**: Module dependencies not found

```powershell
# Solution: Reinstall dependencies
Invoke-PSDepend -Path ./requirements.psd1 -Install -Import -Force
```

### Test Failures

**Problem**: Pester version conflicts

```powershell
# Solution: Install correct Pester version
Install-Module -Name Pester -RequiredVersion 5.7.1 -Force -SkipPublisherCheck
```

**Problem**: Tests can't find functions

```powershell
# Solution: Ensure dot-sourcing is correct in test file
BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}
```

### Import Issues

**Problem**: Module doesn't import after building

```powershell
# Solution: Verify module manifest is valid
Test-ModuleManifest ./build/out/YourModuleName/YourModuleName.psd1

# Check for errors
Import-Module ./build/out/YourModuleName/YourModuleName.psd1 -Verbose
```

**Problem**: Functions not exported

```powershell
# Solution: Check FunctionsToExport in manifest
# Either list functions explicitly or use '*' for all Public functions
```

## Next Steps

Now that you're set up, learn more about:

- 📖 [Development Workflow](development.md) - Building, testing, and documentation
- 🔄 [CI/CD & Publishing](ci-cd.md) - Automated releases and PowerShell Gallery publishing
- 🤖 [AGENTS.md](../AGENTS.md) - Guidelines for AI coding assistants

## Additional Resources

- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [Pester Documentation](https://pester.dev/)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer)
- [Semantic Versioning](https://semver.org/)

---

**Ready to build something awesome? Let's code! 🚀**
