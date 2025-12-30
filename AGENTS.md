# AI Agents Guide for PSScriptModule.Template

This document provides guidance for AI coding agents (like GitHub Copilot, Cursor, or other AI assistants) working with this PowerShell module template project.

## Project Overview

**Project Type**: PowerShell Script Module Template  
**Language**: PowerShell  
**Build System**: Invoke-Build  
**Testing Framework**: Pester  
**Code Analysis**: PSScriptAnalyzer  
**Documentation**: PlatyPS (markdown-based help)

## Project Structure

```
PSScriptModule.Template/
├── src/                          # Source code
│   ├── PSScriptModule.psd1      # Module manifest
│   ├── Public/                   # Public functions (exported)
│   └── Private/                  # Private functions (internal)
├── tests/                        # Test suites
│   ├── PSScriptAnalyzer/        # Code analysis tests
│   └── InjectionHunter/         # Security tests
├── docs/help/                    # Markdown documentation
├── PSScriptModule.build.ps1     # Build script
├── requirements.psd1            # Dependencies (PSDepend)
└── gitversion.yml              # Versioning configuration
```

## Key Conventions

### File Naming
- Public functions: `Verb-Noun.ps1` in `src/Public/`
- Private functions: `VerbNoun.ps1` in `src/Private/`
- Test files: `*.Tests.ps1` alongside source files
- Help files: `Verb-Noun.md` in `docs/help/`

### Function Structure
- Use approved PowerShell verbs (Get, Set, New, Remove, etc.)
- Include `[CmdletBinding()]` attribute
- Add comprehensive comment-based help
- Use parameter validation attributes
- Follow begin/process/end blocks when appropriate

### Testing Requirements
- Every function must have corresponding `.Tests.ps1` file
- Use Pester framework (v5+)
- Organize tests with Describe/Context/It blocks
- Test both success and failure scenarios
- Mock external dependencies

### Code Quality
- Must pass PSScriptAnalyzer with default rules
- Follow PSScriptAnalyzerSettings.psd1 configuration
- Check for security issues (injection attacks, etc.)
- No hard-coded credentials or sensitive data

## Build Tasks

Available Invoke-Build tasks:

```powershell
Invoke-Build                          # Default: Clean + Build
Invoke-Build Clean                    # Remove build artifacts
Invoke-Build Build                    # Build the module
Invoke-Build Test                     # Run all tests
Invoke-Build Invoke-PSScriptAnalyzer  # Run static analysis
Invoke-Build Invoke-Pester            # Run Pester tests
```

## AI Agent Instructions

### When Creating New Functions

1. **Placement**:
   - Public functions → `src/Public/Verb-Noun.ps1`
   - Private functions → `src/Private/VerbNoun.ps1`

2. **Function Template**:
   ```powershell
   function Verb-Noun {
       <#
       .SYNOPSIS
           Brief one-line description
       
       .DESCRIPTION
           Detailed description of what the function does
       
       .PARAMETER ParameterName
           Description of the parameter
       
       .EXAMPLE
           Verb-Noun -ParameterName 'Value'
           Description of what this example demonstrates
       
       .OUTPUTS
           Type of output returned (if any)
       
       .NOTES
           Additional information
       #>
       [CmdletBinding()]
       param (
           [Parameter(Mandatory)]
           [ValidateNotNullOrEmpty()]
           [string]
           $ParameterName
       )
       
       begin {
           Write-Verbose "Starting $($MyInvocation.MyCommand)"
       }
       
       process {
           try {
               # Implementation here
           }
           catch {
               Write-Error "Error in $($MyInvocation.MyCommand): $_"
               throw
           }
       }
       
       end {
           Write-Verbose "Completed $($MyInvocation.MyCommand)"
       }
   }
   ```

3. **Create Test File**:
   ```powershell
   BeforeAll {
       # Import the function
       . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
   }
   
   Describe 'Verb-Noun' {
       Context 'Parameter Validation' {
           It 'Should throw when ParameterName is null or empty' {
               { Verb-Noun -ParameterName '' } | Should -Throw
           }
       }
       
       Context 'Functionality' {
           It 'Should return expected result' {
               $result = Verb-Noun -ParameterName 'test'
               $result | Should -Not -BeNullOrEmpty
           }
       }
   }
   ```

### When Modifying Existing Code

1. **Verify Tests**: Ensure existing tests still pass
2. **Update Tests**: Add new tests for new functionality
3. **Update Help**: Regenerate markdown help if function signature changes
4. **Check Analysis**: Run PSScriptAnalyzer to verify compliance
5. **Semantic Versioning**: Include appropriate `+semver:` keyword in commits

### Code Quality Checklist

Before completing any code changes, verify:

- [ ] Function uses approved PowerShell verb
- [ ] Parameter validation attributes are used
- [ ] Comment-based help is complete and accurate
- [ ] `.Tests.ps1` file exists with adequate coverage
- [ ] Code passes `Invoke-Build Invoke-PSScriptAnalyzer`
- [ ] All tests pass with `Invoke-Build Test`
- [ ] No hard-coded paths or credentials
- [ ] Error handling is implemented with try/catch
- [ ] Verbose output is provided for troubleshooting
- [ ] Function is added to FunctionsToExport in .psd1 (if public)

### Common Patterns

**Error Handling**:
```powershell
try {
    # Operation
}
catch {
    Write-Error "Failed to perform operation: $_"
    throw
}
```

**Verbose Output**:
```powershell
Write-Verbose "Performing action on $Target"
```

**Parameter Validation**:
```powershell
[Parameter(Mandatory)]
[ValidateNotNullOrEmpty()]
[ValidateScript({ Test-Path $_ })]
[string]
$Path
```

**Should Process (for destructive operations)**:
```powershell
[CmdletBinding(SupportsShouldProcess)]
param()

if ($PSCmdlet.ShouldProcess($Target, "Operation")) {
    # Perform operation
}
```

### Dependencies

Install required modules via PSDepend:
```powershell
Invoke-PSDepend -Path ./requirements.psd1 -Install -Import -Force
```

Key dependencies:
- **InvokeBuild**: Build orchestration
- **Pester**: Testing framework
- **PSScriptAnalyzer**: Static code analysis
- **platyPS**: Help documentation generation

### Versioning Strategy

- Uses GitVersion with GitHub Flow
- Every PR merge to `main` creates a new release
- Control version bumps with commit message keywords:
  - `+semver: major` - Breaking changes (1.0.0 → 2.0.0)
  - `+semver: minor` - New features (1.0.0 → 1.1.0)
  - `+semver: patch` - Bug fixes (1.0.0 → 1.0.1)
  - `+semver: none` - No version change

### Testing Commands

```powershell
# Run all tests
Invoke-Build Test

# Run specific test file
Invoke-Pester -Path ./src/Public/Get-PSScriptModuleInfo.Tests.ps1

# Run with code coverage
Invoke-Pester -Configuration @{
    CodeCoverage = @{
        Enabled = $true
        Path = './src/**/*.ps1'
    }
}

# Run PSScriptAnalyzer
Invoke-ScriptAnalyzer -Path ./src -Recurse
```

## Best Practices for AI Agents

1. **Always run tests** after making changes
2. **Follow existing patterns** in the codebase
3. **Don't remove or modify** PSScriptAnalyzer suppressions without understanding them
4. **Update documentation** when changing function signatures
5. **Use approved verbs** from `Get-Verb` output
6. **Avoid aliases** in production code (use full cmdlet names)
7. **Include examples** in help documentation
8. **Handle errors explicitly** with try/catch blocks
9. **Add verbose output** for debugging
10. **Test edge cases** including null/empty inputs

## Resources

- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [Pester Documentation](https://pester.dev/)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer)
- [PlatyPS Documentation](https://github.com/PowerShell/platyPS)
- [Semantic Versioning](https://semver.org/)

## Quick Reference

### File Operations
```powershell
# Create new public function
New-Item -Path ./src/Public/Get-Something.ps1 -ItemType File

# Create test file
New-Item -Path ./src/Public/Get-Something.Tests.ps1 -ItemType File
```

### Build Operations
```powershell
# Clean build
Invoke-Build Clean

# Full build
Invoke-Build

# Test only
Invoke-Build Test

# Release build
Invoke-Build -ReleaseType Release
```

### Module Operations
```powershell
# Import module for testing
Import-Module ./src/PSScriptModule.psd1 -Force

# Get module info
Get-Module PSScriptModule

# Remove module
Remove-Module PSScriptModule
```

---

**Note for AI Agents**: This project follows enterprise PowerShell development standards. Always prioritize code quality, testing, and documentation. When in doubt, follow existing patterns in the codebase.
