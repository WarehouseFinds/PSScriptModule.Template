# {MODULE_NAME}

{MODULE_DESCRIPTION}

[![Build Status](https://img.shields.io/github/actions/workflow/status/{MODULE_PATH}/ci.yml?branch=main&logo=github&style=flat-square)](https://github.com/{MODULE_PATH}/actions/workflows/ci.yml)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/{MODULE_NAME}.svg)](https://www.powershellgallery.com/packages/{MODULE_NAME})
[![Downloads](https://img.shields.io/powershellgallery/dt/{MODULE_NAME}.svg)](https://www.powershellgallery.com/packages/{MODULE_NAME})
[![License](https://img.shields.io/github/license/{MODULE_PATH})](LICENSE)

## 📂 Project Structure

```plaintext
{MODULE_NAME}/
├── 📄 {MODULE_NAME}.build.ps1       # Invoke-Build script with all build tasks
├── 📄 requirements.psd1             # PSDepend configuration for dependencies
├── 📄 gitversion.yml                # GitVersion configuration
├── 📄 CONTRIBUTING.md               # Contribution guidelines
├── 📄 AGENTS.md                     # AI agent instructions
├── 📁 src/                          # Source code
│   ├── 📄 {MODULE_NAME}.psd1      # Module manifest
│   ├── 📁 Public/                   # Public functions (exported)
│   │   ├── Get-PSScriptModuleInfo.ps1
│   │   └── Get-PSScriptModuleInfo.Tests.ps1
│   └── 📁 Private/                  # Private functions (internal only)
│       ├── GetModuleId.ps1
│       └── GetModuleId.Tests.ps1
├── 📁 tests/                        # Test suites
│   ├── 📁 PSScriptAnalyzer/        # Static code analysis tests
│   │   ├── PSScriptAnalyzer.Tests.ps1
│   │   └── PSScriptAnalyzerSettings.psd1
│   └── 📁 InjectionHunter/         # Security vulnerability tests
│       └── InjectionHunter.Tests.ps1
├── 📁 docs/help/                    # Markdown documentation
│   └── Get-PSScriptModuleInfo.md
└── 📁 build/                        # Build output (generated)
    ├── 📁 src/                      # Copied source for building
    ├── 📁 out/                      # Compiled module output
    └── 📁 help/                     # Generated help files
```

## 🚀 Getting Started

### Prerequisites

- **PowerShell 7.0+** (or PowerShell 5.1 minimum)
- **Git** for version control
- **Internet connection** for installing dependencies

### Quick Start

1. **Clone or use this template:**

   ```bash
   git clone https://github.com/{MODULE_PATH}.git {MODULE_NAME}
   cd {MODULE_NAME}
   ```

1. **Install dependencies:**

   ```powershell
   # Install PSDepend if not already installed
   Install-Module -Name PSDepend -Scope CurrentUser -Force
   
   # Install all project dependencies
   Invoke-PSDepend -Path ./requirements.psd1 -Install -Import -Force
   ```

1. **Build and test:**

   ```powershell
   # Run default build (Clean + Build)
   Invoke-Build
   
   # Run all tests
   Invoke-Build Test
   ```

## 🔧 Build Tasks

The template includes several pre-configured build tasks:

```powershell
# Clean + Build (default)
Invoke-Build

# Individual tasks
Invoke-Build Clean                    # Remove build artifacts
Invoke-Build Build                    # Build the module
Invoke-Build Test                     # Run all tests
Invoke-Build Invoke-PSScriptAnalyzer  # Run static code analysis
Invoke-Build Invoke-InjectionHunter   # Run security scans
Invoke-Build Invoke-UnitTests         # Run Pester tests with coverage
Invoke-Build Export-CommandHelp       # Generate documentation
Invoke-Build Publish                  # Publish to PowerShell Gallery

# Build for different configurations
Invoke-Build -ReleaseType Debug       # Development build
Invoke-Build -ReleaseType Release     # Production build
Invoke-Build -ReleaseType Prerelease  # Pre-release build
```

## 🧪 Testing

### Running Tests

```powershell
# Run all tests (unit, analysis, security)
Invoke-Build Test

# Run specific test types
Invoke-Build Invoke-UnitTests         # Unit tests only
Invoke-Build Invoke-PSScriptAnalyzer  # Code analysis only
Invoke-Build Invoke-InjectionHunter   # Security scans only

# Run with code coverage
Invoke-Pester -Configuration @{
    CodeCoverage = @{
        Enabled = $true
        Path = './src/**/*.ps1'
    }
}
```

### Test Output

All test results are saved to `test-results/` directory:

- `unit-tests.xml` - Pester test results (NUnit XML)
- `code-coverage.xml` - Code coverage report (Cobertura)
- `static-code-analysis.xml` - PSScriptAnalyzer results
- `code-injection.xml` - InjectionHunter security scan results

## 📚 Documentation

### Generating Help

```powershell
# Generate markdown and MAML help files
Invoke-Build Export-CommandHelp
```

Help files are generated in two formats:

1. **Markdown** (`.md`) - Stored in `docs/help/` for web/GitHub viewing
1. **MAML** (`.xml`) - Stored in module's `en-US/` folder for `Get-Help` command

### Using Help in PowerShell

```powershell
# Import your module
Import-Module ./build/out/{MODULE_NAME}/{MODULE_NAME}.psd1

# View help
Get-Help Get-PSScriptModuleInfo -Full
Get-Help Get-PSScriptModuleInfo -Examples
Get-Help Get-PSScriptModuleInfo -Online
```

## 🔄 CI/CD Pipeline

The template includes a comprehensive CI/CD pipeline that runs automatically on pull requests and pushes to main.

### Pipeline Structure

The CI workflow orchestrates multiple jobs in parallel:

1. **Setup** - Caches PowerShell module dependencies for faster builds
1. **Unit Tests** - Runs Pester tests with code coverage reporting
1. **Static Code Analysis** - Validates code with PSScriptAnalyzer rules
1. **Code Injection Analysis** - Scans for injection vulnerabilities with InjectionHunter
1. **Semantic Code Analysis** - Runs CodeQL security analysis
1. **Build** - Compiles module, generates help, creates releases, and publishes to PowerShell Gallery

### Workflow Triggers

- **Pull Request**: Runs all quality gates (tests not run for workflow-only changes)
- **Push to main**: Runs full pipeline and creates prerelease
- **Workflow Dispatch**: Manual trigger with custom version and publish options
- **Schedule**: Weekly CodeQL security scan

### Build Types

The pipeline automatically determines the build type:

| Event | Build Type | Version Format | Published |
| ----- | ---------- | -------------- | --------- |
| Pull Request | Debug | `1.2.3-PullRequest1234` | No |
| Push to main | Prerelease | `1.2.3-Prerelease` | Yes |
| Manual (workflow_dispatch) | Release | `1.2.3` | Optional |

## 🔄 Versioning Strategy

This template uses **Semantic Versioning** (SemVer) with automated version management through GitVersion.

### GitVersion Configuration

- **Workflow**: GitHub Flow (main branch + feature branches)
- **Strategy**: Every PR merge to `main` creates a new release
- **Version calculation**: Based on commit history and tags

### Controlling Version Bumps

Include one of these keywords in your commit message:

| Keyword | Version Change | Example |
| ------- | -------------- | ------- |
| `+semver: breaking` or `+semver: major` | Major (1.0.0 → 2.0.0) | Breaking changes |
| `+semver: feature` or `+semver: minor` | Minor (1.0.0 → 1.1.0) | New features |
| `+semver: fix` or `+semver: patch` | Patch (1.0.0 → 1.0.1) | Bug fixes |
| `+semver: none` or `+semver: skip` | No change | Documentation updates |

### Example Commit Messages

```bash
git commit -m "Add new Get-Something function +semver: minor"
git commit -m "Fix parameter validation bug +semver: patch"
git commit -m "Remove deprecated function +semver: breaking"
git commit -m "Update README +semver: none"
```

## 🛠️ Development Workflow

### Creating New Functions

1. **Create function file** in `src/Public/` or `src/Private/`:

   ```powershell
   # src/Public/Get-Something.ps1
   function Get-Something {
       <#
       .SYNOPSIS
           Brief description
       
       .DESCRIPTION
           Detailed description
       
       .PARAMETER Name
           Parameter description
       
       .EXAMPLE
           Get-Something -Name 'Example'
           Description of example
       #>
       [CmdletBinding()]
       param (
           [Parameter(Mandatory)]
           [string]$Name
       )
       
       # Implementation
   }
   ```

1. **Create test file** alongside function:

   ```powershell
   # src/Public/Get-Something.Tests.ps1
   BeforeAll {
       . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
   }
   
   Describe 'Get-Something' {
       It 'Should return expected result' {
           $result = Get-Something -Name 'test'
           $result | Should -Not -BeNullOrEmpty
       }
   }
   ```

1. **Update module manifest** if adding public function:

   ```powershell
   # Add to FunctionsToExport in PSScriptModule.psd1
   FunctionsToExport = @('Get-PSScriptModuleInfo', 'Get-Something')
   ```

1. **Build and test**:

   ```powershell
   Invoke-Build Test
   ```

### Making Changes

1. Create feature branch: `git checkout -b feature/my-feature`
1. Make your changes
1. Run tests: `Invoke-Build Test`
1. Commit with semver keyword: `git commit -m "Add feature +semver: minor"`
1. Push and create Pull Request
1. After PR merge, automatic release is triggered

## 📦 Publishing to PowerShell Gallery

### Manual Publishing

```powershell
Invoke-Build -ReleaseType Release -NugetApiKey 'YOUR-API-KEY'
```

### Automated Publishing (CI/CD)

Configure your GitHub repository secrets:

- `NUGETAPIKEY_PSGALLERY` - Your PowerShell Gallery API key

The CI/CD pipeline will automatically publish on release.

### Manual Workflow Dispatch

You can manually trigger builds and releases via GitHub Actions workflow dispatch:

1. **Navigate to Actions** → CI workflow
1. **Click "Run workflow"**
1. **Configure options**:
   - `version-tag`: Specify a version tag to build (e.g., `v0.9.7`) - leave empty to use current commit
   - `publish`: Check to publish the release to PowerShell Gallery

This is useful for:

- Creating releases from specific commits or tags
- Re-publishing existing versions
- Testing release workflows before merging to main

## 🤝 Contributing

We welcome contributions! Please see our [CONTRIBUTING.md](CONTRIBUTING.md) guide for:

- How to report issues
- Pull request process
- Code style guidelines
- Testing requirements

## 🤖 AI Agent Support

This repository includes special documentation for AI coding assistants. See [AGENTS.md](AGENTS.md) for:

- Project structure and conventions
- Function templates and patterns
- Testing guidelines
- Code quality requirements

## 📋 Dependencies

This template uses the following PowerShell modules:

| Module | Version | Purpose |
| ------ | ------- | ------- |
| **InvokeBuild** | 5.14.22 | Build orchestration |
| **ModuleBuilder** | 3.1.8 | Module compilation |
| **Pester** | 5.7.1 | Testing framework |
| **PSScriptAnalyzer** | latest | Static code analysis |
| **InjectionHunter** | 1.0.0 | Security vulnerability scanning |
| **Microsoft.PowerShell.PlatyPS** | 1.0.1 | Help documentation generation |

All dependencies are managed through `requirements.psd1` and can be installed with PSDepend.

## 📝 License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

## 🎓 Learning Resources

- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [Pester Documentation](https://pester.dev/)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer)
- [Semantic Versioning](https://semver.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

## 🆘 Support

- 📖 Check the [CONTRIBUTING.md](CONTRIBUTING.md) guide
- 🐛 [Report issues](https://github.com/{MODULE_PATH}/issues)
- 💬 [Start a discussion](https://github.com/{MODULE_PATH}/discussions)

---

**Built with ❤️ by [Warehouse Finds](https://github.com/WarehouseFinds)**
