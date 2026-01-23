# GitHub Copilot Instructions

This file provides context and guidance for GitHub Copilot when working with this PowerShell module project.

## TL;DR for AI Agents

- Create small, focused functions
- Always add tests
- Never weaken validation or security
- Follow existing patterns
- Prefer explicit, boring, auditable code

## Project Context

This is a **PowerShell Script Module Template** project designed for building production-ready PowerShell modules with:

- **Build System**: Invoke-Build for task automation
- **Testing**: Pester 5+ for unit testing
- **Code Quality**: PSScriptAnalyzer for static analysis
- **Security**: InjectionHunter for vulnerability scanning
- **Documentation**: PlatyPS for markdown-based help generation
- **Versioning**: GitVersion with semantic versioning
- **CI/CD**: GitHub Actions for automated testing and publishing

## Project Structure

```
src/
├── PSScriptModule.psd1      # Module manifest (auto-updated)
├── Public/                   # Exported functions
├── Private/                  # Internal helper functions
└── Classes/                  # PowerShell classes

tests/
├── PSScriptAnalyzer/        # Code analysis configuration
└── InjectionHunter/         # Security test configuration

docs/
├── getting-started.md       # Setup and initial development
├── development.md           # Development workflow guide
├── ci-cd.md                 # CI/CD and publishing guide
└── help/                    # Auto-generated function help
```

## AI Intent

Code generated in this repository is production-facing and reused by others.
Prefer correctness, clarity, and testability over brevity or cleverness.

## Protected Areas

The following areas should not be modified without explicit instruction:

- CI/CD workflows
- Versioning configuration
- Publishing logic
- Security scanning configuration

## When Uncertain

If requirements are ambiguous:
- Follow existing patterns in the repository
- Prefer private helper functions over changing public APIs
- Add tests that document assumptions

## Development Principles

This project follows key software engineering principles:

### Fail Fast

**Detect and report errors as early as possible**

- Use strict parameter validation (`[ValidateNotNullOrEmpty()]`, `[ValidateScript()]`, etc.)
- Validate inputs at function boundaries before processing
- Throw meaningful exceptions immediately when invalid conditions are detected
- Don't allow bad data to propagate through the system
- Use `$ErrorActionPreference = 'Stop'` in critical sections when appropriate

**Example:**

```powershell
function Get-UserData {
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$UserId
    )
    
    # Fail fast: Validate before proceeding
    if ($UserId -notmatch '^\d{5}$') {
        throw "UserId must be exactly 5 digits. Received: $UserId"
    }
    
    # Continue with processing only if validation passes
    # ...
}
```

### Open-Closed Principle

**Open for extension, closed for modification**

- Design functions to be extensible without modifying existing code
- Use parameter sets to add new functionality
- Leverage pipeline input for composability
- Create new functions rather than modifying working ones
- Use private helper functions to keep public APIs stable

**Example:**

```powershell
# Good: Extensible through parameters
function Get-Data {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(ParameterSetName = 'Default')]
        [string]$Name,
        
        [Parameter(ParameterSetName = 'ById')]
        [int]$Id,
        
        [Parameter(ParameterSetName = 'Advanced')]
        [hashtable]$Filter
    )
    
    # Extension through parameter sets without modifying core logic
}

# Bad: Modifying function signature breaks existing users
# Instead of changing Get-Data, create Get-DataAdvanced or add parameter set
```

## Code Style and Conventions

### Function Naming and Structure

**Public Functions** (exported to users):
- File location: `src/Public/`
- Naming: `Verb-Noun.ps1` (e.g., `Get-Something.ps1`)
- Must use approved PowerShell verbs (run `Get-Verb` to check)
- Always include `[CmdletBinding()]`
- Must have comprehensive comment-based help
- Automatically exported from the module

**Private Functions** (internal only):
- File location: `src/Private/`
- Naming: `VerbNoun.ps1` or descriptive name
- Not exported to module users

### Function Template

When creating new functions, use this template:

```powershell
function Verb-Noun {
    <#
    .SYNOPSIS
        Brief one-line description
    
    .DESCRIPTION
        Detailed description of functionality
    
    .PARAMETER Name
        Parameter description
    
    .EXAMPLE
        Verb-Noun -Name 'Value'
        Description of what this example does
    
    .OUTPUTS
        Type of output returned
    
    .NOTES
        Additional notes or requirements
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )
    
    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
    }
    
    process {
        try {
            if ($PSCmdlet.ShouldProcess($Name, 'Action')) {
                # Implementation here
            }
        }
        catch {
            Write-Error "Error: $_"
            throw
        }
    }
    
    end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}
```

### Test File Template

Every function must have a corresponding `.Tests.ps1` file:

```powershell
BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'Verb-Noun' {
    Context 'Parameter Validation' {
        It 'Should require mandatory parameters' {
            { Verb-Noun } | Should -Throw
        }
        
        It 'Should not accept null or empty values' {
            { Verb-Noun -Name '' } | Should -Throw
        }
    }
    
    Context 'Functionality' {
        It 'Should return expected result' {
            $result = Verb-Noun -Name 'Test'
            $result | Should -Not -BeNullOrEmpty
        }
    }
    
    Context 'Pipeline Support' {
        It 'Should accept pipeline input' {
            { 'Test' | Verb-Noun } | Should -Not -Throw
        }
    }
}
```

## Key Guidelines

### DO:

✅ Use approved PowerShell verbs (`Get-Verb` to list)  
✅ Include comprehensive comment-based help  
✅ Add parameter validation attributes  
✅ Create `.Tests.ps1` file for every function  
✅ Use `Write-Verbose` for debugging output  
✅ Use `Write-Error` for error messages  
✅ Support `-WhatIf` for destructive operations (`SupportsShouldProcess`)  
✅ Support pipeline input where appropriate  
✅ Follow begin/process/end pattern for pipeline processing  
✅ Test both success and failure scenarios  
✅ Mock external dependencies in tests  

### DON'T:

❌ Use aliases in production code (e.g., `gci` instead of `Get-ChildItem`)  
❌ Hard-code paths, credentials, or environment-specific values  
❌ Suppress errors without good reason  
❌ Skip parameter validation  
❌ Forget to create test files  
❌ Use `Write-Host` unless absolutely necessary  
❌ Mix output types from the same function  
❌ Manually update `FunctionsToExport` in manifest (it's automatic)  

## Building and Testing

### Common Commands

```powershell
# Build the module
Invoke-Build                          # Clean + Build

# Run all tests
Invoke-Build Test

# Run specific test types
Invoke-Build Invoke-UnitTests         # Pester tests only
Invoke-Build Invoke-PSScriptAnalyzer  # Code analysis
Invoke-Build Invoke-InjectionHunter   # Security scan

# Generate help documentation
Invoke-Build Export-CommandHelp

# Test the built module
Import-Module ./build/out/PSScriptModule/PSScriptModule.psd1 -Force
Get-Command -Module PSScriptModule
```

### Test Expectations

- **Coverage Target**: 80%+ code coverage
- **All tests must pass** before committing
- **PSScriptAnalyzer** must pass with no errors
- **Security scans** must pass

## Version Control

### Commit Message Format

Include semantic versioning keywords in commit messages:

```bash
# Minor version bump (new feature)
git commit -m "Add Get-Something function +semver: minor"

# Patch version bump (bug fix)
git commit -m "Fix parameter validation +semver: patch"

# Major version bump (breaking change)
git commit -m "Remove deprecated function +semver: major"

# No version change (documentation only)
git commit -m "Update README +semver: none"
```

## Common Patterns

### Error Handling

```powershell
try {
    $result = Invoke-Operation
}
catch {
    Write-Verbose "$($MyInvocation.MyCommand) Operation failed: $_"
    Write-Verbose "StackTrace: $($_.ScriptStackTrace)"
    throw $_
}
```

### Parameter Validation

```powershell
[Parameter(Mandatory)]
[ValidateNotNullOrEmpty()]
[ValidateScript({ Test-Path $_ })]
[ValidateSet('Option1', 'Option2', 'Option3')]
[string]
$ParameterName
```

### Pipeline Support

```powershell
[CmdletBinding()]
param (
    [Parameter(
        Mandatory,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName
    )]
    [string]
    $Name
)

begin {
    $results = [System.Collections.Generic.List[object]]::new()
}

process {
    # Process each pipeline item
    $results.Add($processedItem)
}

end {
    return $results
}
```

### WhatIf/Confirm Support

```powershell
[CmdletBinding(SupportsShouldProcess)]
param()

if ($PSCmdlet.ShouldProcess($Target, 'Action to perform')) {
    # Perform the action
}
```

## Testing Patterns

### Mocking External Commands

```powershell
BeforeAll {
    Mock Invoke-RestMethod {
        return @{ Status = 'Success'; Data = 'Mocked' }
    }
}

It 'Should call external API' {
    $result = Get-Something
    Should -Invoke Invoke-RestMethod -Exactly 1
}
```

### Testing Exceptions

```powershell
It 'Should throw on invalid input' {
    { Get-Something -Name $null } | Should -Throw
    { Get-Something -Name '' } | Should -Throw '*cannot be empty*'
}
```

### Testing Output Types

```powershell
It 'Should return correct type' {
    $result = Get-Something
    $result | Should -BeOfType [PSCustomObject]
    $result.PropertyName | Should -BeOfType [string]
}
```

## Documentation

### Help Documentation

- Update comment-based help in function when changing parameters
- Run `Invoke-Build Export-CommandHelp` to regenerate help files
- Markdown help is generated in `docs/help/`
- MAML help (`.xml`) is generated for `Get-Help` command

### Project Documentation

Comprehensive guides are available:
- `docs/getting-started.md` - Setup and first steps
- `docs/development.md` - Development workflow
- `docs/ci-cd.md` - CI/CD and publishing

## CI/CD Integration

### GitHub Actions Workflow

- **Triggers**: Pull requests, pushes to main, manual dispatch
- **Quality Gates**: Unit tests, code analysis, security scans
- **Automated**: Version bumping, releases, publishing

### Pipeline Support Guidance

- Support pipeline input only when it improves usability
- Do not force pipeline support for configuration or control functions
- Pipeline support must be tested explicitly

## Quick Reference

### File Locations

- **New public function**: `src/Public/Verb-Noun.ps1`
- **New private function**: `src/Private/VerbNoun.ps1`
- **Test file**: Same location as function, add `.Tests.ps1` suffix
- **Build script**: `PSScriptModule.build.ps1`
- **Module manifest**: `src/PSScriptModule.psd1`

### Need Help?

- Check `docs/` for comprehensive documentation
- Run `Invoke-Build ?` to list all available tasks
- Review existing functions for patterns and examples

---

**Remember**: This is a template project. Code you generate will be used by other developers, so prioritize clarity, testing, and documentation.
