# PSScriptModule - PowerShell Script Module Template

> A modern PowerShell module template with CI/CD, testing, semantic versioning, and automated publishing

A production-ready PowerShell module template with built-in CI/CD, testing, versioning, and publishing workflows using GitHub Actions.

[![CI](https://github.com/WarehouseFinds/PSScriptModule/actions/workflows/ci.yml/badge.svg)](https://github.com/WarehouseFinds/PSScriptModule/actions/workflows/ci.yml)
[![Code Coverage](https://img.shields.io/github/actions/workflow/status/WarehouseFinds/PSScriptModule/ci.yml?branch=main&label=code%20coverage)](https://github.com/WarehouseFinds/PSScriptModule/actions/workflows/ci.yml)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSScriptModule.svg)](https://www.powershellgallery.com/packages/PSScriptModule)
[![Downloads](https://img.shields.io/powershellgallery/dt/PSScriptModule.svg)](https://www.powershellgallery.com/packages/PSScriptModule)
[![License](https://img.shields.io/github/license/WarehouseFinds/PSScriptModule)](LICENSE)

## 💡 Why This Template?

Most PowerShell module repositories start the same way: a few scripts, some manual testing, and CI/CD added later—often inconsistently. This template flips that model.

**PSScriptModule is opinionated by design.**  
It gives you a complete, production-grade foundation so you can focus on writing PowerShell code—not wiring pipelines.

### What makes it different?

- **CI/CD from day one**  
  Build, test, analyze, version, and publish automatically using GitHub Actions.

- **Best practices baked in**  
  Module structure, testing, security scanning, and documentation follow proven PowerShell and DevOps conventions.

- **Automation over ceremony**  
  Versioning, changelogs, releases, and publishing happen automatically based on your commits and pull requests.

- **Works everywhere**  
  Tested on Windows, Linux, and macOS, with optional devcontainer support for consistent environments.

- **Scales with your project**  
  Suitable for prototypes, internal tooling, and fully open-source modules published to the PowerShell Gallery.

If you’ve ever thought *“I just want to write PowerShell, not build pipelines”*, this template is for you.

## 🎬 How to Use This Template

1. Click the "Use PowerShell Module Template" button below or use GitHub's "Use this template" button
1. Fill in your module name and description
1. Wait **about 20 seconds** for the automated bootstrap workflow to complete
1. **Refresh the page** to see your customized repository

[![](https://img.shields.io/badge/Use%20Powershell%20Template-%E2%86%92-1f883d?style=for-the-badge&logo=github&labelColor=197935)](https://github.com/new?template_owner=WarehouseFinds&template_name=PSScriptModule&owner=%40me&name=MyProject&description=PS%20Module%20Template&visibility=public)

## 📦 Features

When you create a module from this template, you get a fully wired, production-ready PowerShell module from day one.

### ✅ CI/CD Ready

- End-to-end GitHub Actions workflows for build, test, release, and publishing
- Dependency management with intelligent caching for faster pipelines
- Cross-platform validation on Windows, Linux, and macOS
- Automated publishing to PowerShell Gallery and NuGet.org

### ✅ Development Environment

- Opinionated VS Code setup (settings and recommended extensions)
- Pre-configured build, run, and debug tasks
- Devcontainer support for consistent, sandboxed development environments

### ✅ Version Management

- Semantic versioning powered by GitVersion
- GitHub Flow–based release strategy
- Commit-driven version bumps using `+semver:` keywords
- Automatic changelog generation from merged pull requests

### ✅ Code Quality and Testing

- Pester-based unit testing framework
- Code coverage reporting
- Built-in security scanning with PSScriptAnalyzer, InjectionHunter, and CodeQL

### ✅ Project Documentation

- Markdown-based help generation using PlatyPS
- Auto-generated external help for `Get-Help`
- Structured, comprehensive documentation in the `/docs` directory

## 📂 Project Structure

```plaintext
PSScriptModule/
├── 📄 PSScriptModule.build.ps1      // Invoke-Build script with all build tasks
├── 📄 requirements.psd1             // PSDepend configuration for dependencies
├── 📄 gitversion.yml                // GitVersion configuration
├── 📄 CONTRIBUTING.md               // Contribution guidelines
├── 📄 AGENTS.md                     // AI agent instructions
├── 📁 src/                          // Source code
│   ├── 📄 PSScriptModule.psd1       // Module manifest
│   ├── 📁 Classes/                  // Classes definitions
│   ├── 📁 Public/                   // Public functions (exported)
│   └── 📁 Private/                  // Private functions (internal only)
├── 📁 tests/                        // Test suites
│   ├── 📁 PSScriptAnalyzer/         // Static code analysis tests
│   └── 📁 InjectionHunter/          // Security vulnerability tests
├── 📁 docs/help/                    // Markdown documentation
└── 📁 build/                        // Build output (generated)
    ├── 📁 src/                      // Copied source for building
    ├── 📁 out/                      // Compiled module output
    └── 📁 help/                     // Generated help files
```

## 🚀 Getting Started

### Prerequisites

**Required:**

- **PowerShell 7.0+**
- **Visual Studio Code** with PowerShell extension (recommended)
- **Git** for version control

*Optional* dependencies:

- **GitHub Copilot** for enhanced development experience
- **Docker or Rancher Desktop** for consistent development environments in devcontainers
- **PowerShell Gallery account** for publishing

### Quick Start

1. Click on the "Use this template" button above to create your own repository from this template.
Personalize it by updating the name, description, and visibility.

1. Clone your new repository locally:

   ```bash
   git clone https://github.com/YourUsername/YourModuleName.git
   cd YourModuleName
   ```

1. Install dependencies:

   > **Note**: If using the devcontainer (`.devcontainer/` folder), dependencies are pre-installed. Skip this step.

   ```powershell
   # Install PSDepend if not already installed
   Install-Module -Name PSDepend -Scope CurrentUser -Force
   
   # Install all project dependencies
   Invoke-PSDepend -Path ./requirements.psd1 -Install -Import -Force
   ```

1. Run build and test tasks:

   ```powershell
   # Run default build (Clean + Build)
   Invoke-Build
   
   # Run all tests
   Invoke-Build Test
   ```

1. You are now ready to start developing your PowerShell module!

### Next Steps

After setup, customize your module:

1. **Update Module Manifest** (`src/YourModuleName.psd1`):
   - Set `Author`, `CompanyName`, `Copyright`
   - Update `Description` and `Tags`

   > **Note**: Do not change `ModuleVersion`, `RootModule`, or `FunctionsToExport`  - it is managed automatically

1. **Start Developing**:
   - Add functions to `src/Public/` (exported) or `src/Private/` (internal)
   - Create corresponding `.Tests.ps1` files

1. **Push your changes** and open a pull request to trigger CI/CD workflows

## Documentation

See the [documentation guides](docs/) for detailed information on:

- [Building](docs/building.md)
- [Testing](docs/testing.md)
- [Generating Help](docs/generating-help.md)
- [Publishing](docs/publishing.md)

## 🤝 Contributing

We welcome contributions! Please see our [CONTRIBUTING](CONTRIBUTING.md) guide for:

- Pull request process
- Code style guidelines
- Testing requirements

## Like this project?

If you find this template useful, please consider supporting it by:

- **Star this repository** if you find it useful
- **Share it** with other PowerShell developers
- **Provide feedback** via issues or discussions
- **Sponsor development** via GitHub Sponsors

---

Built with ❤️ by [Warehouse Finds](https://github.com/WarehouseFinds)
