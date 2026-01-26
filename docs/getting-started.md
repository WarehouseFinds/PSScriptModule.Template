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

Quick tweaks to make the template yours. For everything beyond setup, use the Development guide.

### Minimal Customization

- Update manifest metadata in `src/YourModuleName.psd1` (Author, CompanyName, Description, ProjectUri, LicenseUri, tags).
- Adjust badges and links in `README.md`.
- Review `LICENSE` and `CONTRIBUTING.md` to match your project.

## Quick Checks

```powershell
# Build once to verify toolchain
Invoke-Build

# (Optional) run tests
Invoke-Build Test
```

## Next Steps

- 📖 Development workflow, function patterns, and tests: [development.md](development.md)
- 🔄 CI/CD and publishing: [ci-cd.md](ci-cd.md)
- 🤖 AI contributor guidance: [AGENTS.md](../AGENTS.md)

## Additional Resources

- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [Pester Documentation](https://pester.dev/)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer)
- [Semantic Versioning](https://semver.org/)

---

**Ready to build something awesome? Let's code! 🚀**
