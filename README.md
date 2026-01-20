# PSScriptModule.Template

A production-ready PowerShell script module template designed to streamline the creation, testing, and delivery of enterprise-grade PowerShell modules. This template implements modern DevOps practices,
automated quality gates, and continuous delivery workflows right out of the box.

[![CI](https://github.com/WarehouseFinds/PSScriptModule/actions/workflows/ci.yml/badge.svg)](https://github.com/WarehouseFinds/PSScriptModule/actions/workflows/ci.yml)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSScriptModule.svg)](https://www.powershellgallery.com/packages/PSScriptModule)
[![License](https://img.shields.io/github/license/WarehouseFinds/PSScriptModule)](LICENSE)

## 🎯 Purpose

This template solves the common challenge of setting up a professional PowerShell module project from scratch. Instead of manually configuring build scripts, testing frameworks, and CI/CD pipelines,
you can clone this repository and start writing your module's business logic immediately.

**Perfect for:**

- 📦 Open-source PowerShell projects
- 🔧 DevOps automation tools
- 🎓 Learning PowerShell module development best practices

## How to Use This Template

Simply copy the template to your account, then give bootstrap action **about 20 seconds** to prepare the repository for you, then **refresh the page**.
The name and description will be automatically set based on your inputs.

[![](https://img.shields.io/badge/Copy%20Powershell%20Module-%E2%86%92-1f883d?style=for-the-badge&logo=github&labelColor=197935)](https://github.com/new?template_owner=WarehouseFinds&template_name=PSScriptModule&owner=%40me&name=PS-&description=PS%20Module%20Template&visibility=public)

## ✨ Key Features

### 🏗️ Structured Project Layout

- **Clear separation of concerns** with dedicated folders for source code, tests, and documentation
- **Public/Private function organization** for proper encapsulation
- **Module manifest (`.psd1`)** with all necessary metadata
- **Standardized naming conventions** for consistency

### 🔨 Automated Build System

- **Invoke-Build orchestration** with predefined build tasks
- **ModuleBuilder integration** for compiling script modules
- **Automated module packaging** ready for distribution
- **Debug and Release configurations** for different build scenarios

### 🧪 Comprehensive Testing

- **Pester 5+ testing framework** for unit tests
- **Code coverage reporting** (Cobertura format)
- **PSScriptAnalyzer integration** for static code analysis
- **InjectionHunter security scanning** for injection vulnerability detection
- **CodeQL semantic analysis** for advanced security scanning
- **Test results in NUnit XML format** for CI/CD integration

### 📚 Documentation Generation

- **PlatyPS integration** for markdown-based help
- **Automated MAML generation** for Get-Help support
- **External help files** (`.xml`) for PowerShell's built-in help system
- **Example-driven documentation** templates

### 🔄 Automated Versioning

- **GitVersion** for semantic versioning based on git history
- **GitHub Flow workflow** for streamlined releases
- **Commit-based version control** using `+semver:` keywords
- **Automatic version updates** in module manifest

### 🚀 CI/CD Ready

- **Pre-configured GitHub Actions** workflows
- **Automated quality gates** (tests, analysis, security scans)
- **Automated releases** on PR merges to main
- **PowerShell Gallery publishing** support
- **Automated cleanup workflows** for managing artifacts and workflow runs
- **Manual workflow dispatch** with version control and publishing options

### 📦 Dependency Management

- **PSDepend** for managing module dependencies
- **Version-pinned dependencies** for reproducible builds
- **Automatic dependency installation** in CI/CD pipelines

## 📂 Project Structure

```plaintext
PSScriptModule.Template/
├── 📄 PSScriptModule.build.ps1      # Invoke-Build script with all build tasks
├── 📄 requirements.psd1             # PSDepend configuration for dependencies
├── 📄 gitversion.yml                # GitVersion configuration
├── 📄 CONTRIBUTING.md               # Contribution guidelines
├── 📄 AGENTS.md                     # AI agent instructions
├── 📁 src/                          # Source code
│   ├── 📄 PSScriptModule.psd1      # Module manifest
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
   git clone https://github.com/WarehouseFinds/PSScriptModule.Template.git MyModule
   cd MyModule
   ```

2. **Install dependencies:**

   ```powershell
   # Install PSDepend if not already installed
   Install-Module -Name PSDepend -Scope CurrentUser -Force
   
   # Install all project dependencies
   Invoke-PSDepend -Path ./requirements.psd1 -Install -Import -Force
   ```

3. **Customize the module:**

   - Update `src/PSScriptModule.psd1` with your module information
   - Rename files and folders from `PSScriptModule` to your module name
   - Add your functions to `src/Public/` and `src/Private/`

4. **Build and test:**

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

# Run Pester directly
Invoke-Pester -Path ./src/Public/Get-PSScriptModuleInfo.Tests.ps1

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
2. **MAML** (`.xml`) - Stored in module's `en-US/` folder for `Get-Help` command

### Using Help in PowerShell

```powershell
# Import your module
Import-Module ./build/out/PSScriptModule/PSScriptModule.psd1

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
2. **Unit Tests** - Runs Pester tests with code coverage reporting
3. **Static Code Analysis** - Validates code with PSScriptAnalyzer rules
4. **Code Injection Analysis** - Scans for injection vulnerabilities with InjectionHunter
5. **Semantic Code Analysis** - Runs CodeQL security analysis
6. **Build** - Compiles module, generates help, creates releases, and publishes to PowerShell Gallery

### Workflow Triggers

- **Pull Request**: Runs all quality gates (tests not run for workflow-only changes)
- **Push to main**: Runs full pipeline and creates prerelease
- **Workflow Dispatch**: Manual trigger with custom version and publish options
- **Schedule**: Weekly CodeQL security scan

### Build Types

The pipeline automatically determines the build type:

| Event | Build Type | Version Format | Published |
| --------- | ---------------- | --------- |
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
| --------- | ---------------- | --------- |
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

2. **Create test file** alongside function:

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

3. **Update module manifest** if adding public function:

   ```powershell
   # Add to FunctionsToExport in PSScriptModule.psd1
   FunctionsToExport = @('Get-PSScriptModuleInfo', 'Get-Something')
   ```

4. **Build and test**:

   ```powershell
   Invoke-Build Test
   ```

### Making Changes

1. Create feature branch: `git checkout -b feature/my-feature`
2. Make your changes
3. Run tests: `Invoke-Build Test`
4. Commit with semver keyword: `git commit -m "Add feature +semver: minor"`
5. Push and create Pull Request
6. After PR merge, automatic release is triggered

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
2. **Click "Run workflow"**
3. **Configure options**:
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
| --------- | ---------------- | --------- |
| **InvokeBuild** | 5.14.22 | Build orchestration |
| **ModuleBuilder** | 3.1.8 | Module compilation |
| **Pester** | 5.7.1 | Testing framework |
| **PSScriptAnalyzer** | latest | Static code analysis |
| **InjectionHunter** | 1.0.0 | Security vulnerability scanning |
| **Microsoft.PowerShell.PlatyPS** | 1.0.1 | Help documentation generation |

All dependencies are managed through `requirements.psd1` and can be installed with PSDepend.

## 📝 License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

## 🌟 Features in Detail

### PSScriptAnalyzer Integration

Enforces PowerShell best practices and catches common mistakes:

- Cmdlet design rules
- Performance optimizations
- Security best practices
- Custom rule configurations via `PSScriptAnalyzerSettings.psd1`

### InjectionHunter Security

Scans for common injection vulnerabilities:

- Command injection risks
- Script injection patterns
- Unsafe variable usage
- SQL injection patterns (if applicable)

### ModuleBuilder

Compiles your script module:

- Combines all `.ps1` files into single `.psm1`
- Updates module version automatically
- Copies required files to output
- Optimizes module loading

### PlatyPS Documentation

Generates professional documentation:

- Markdown help files for each command
- MAML files for PowerShell's Get-Help
- Module-level documentation
- Example sections for usage

### CodeQL Semantic Analysis

Advanced security scanning with GitHub CodeQL:

- Runs weekly on a schedule
- Integrates with GitHub Security tab
- Detects complex security vulnerabilities
- Provides actionable security insights

### Automated Maintenance Workflows

Keep your repository clean with automated maintenance:

- **Artifact Cleanup**: Automatically removes artifacts older than 2 days (configurable)
- **Workflow Run Cleanup**: Removes old workflow runs to keep history manageable
- Configurable retention period (default: 2 days)
- Configurable minimum runs to keep (default: 2)
- Separate cleanup for pull requests, pushes, and scheduled runs
- Runs daily at midnight via cron schedule
- Can be triggered manually with custom parameters

## 🎓 Learning Resources

- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [Pester Documentation](https://pester.dev/)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer)
- [Semantic Versioning](https://semver.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)

## 🆘 Support

- 📖 Check the [CONTRIBUTING.md](CONTRIBUTING.md) guide
- 🐛 [Report issues](https://github.com/WarehouseFinds/PSScriptModule.Template/issues)
- 💬 [Start a discussion](https://github.com/WarehouseFinds/PSScriptModule.Template/discussions)

---

**Built with ❤️ by [Warehouse Finds](https://github.com/WarehouseFinds)**
