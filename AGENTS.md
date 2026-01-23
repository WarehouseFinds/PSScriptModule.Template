# AI Coding Agent Guidelines

This document provides guidance for AI coding assistants (Copilot, Claude, etc.) when generating code in this repository.  
All code should be **production-ready, maintainable, tested, and auditable**.

---

## Purpose

AI agents must generate code that:

- Preserves existing behavior and public APIs
- Follows PowerShell best practices
- Includes proper testing, validation, and error handling
- Is readable, secure, and auditable
- Can be integrated into CI/CD pipelines without modification

---

## Hard Rules (Must Follow)

- Preserve original exception types and stack traces; never throw strings instead of exceptions
- Maintain function parameter validation (`[ValidateNotNullOrEmpty()]`, `[ValidateScript()]`, etc.)
- Do not remove or bypass existing tests, analyzers, or security scans
- Avoid writing secrets, credentials, or environment-specific paths in code
- Use approved PowerShell verbs (`Get-Verb`) and proper file naming
- Always create a `.Tests.ps1` file for each new function
- Follow begin/process/end pattern for functions that support pipeline input
- Do not use aliases in production code (e.g., `gci` instead of `Get-ChildItem`)
- Always include `[CmdletBinding()]` in public functions

---

## Coding Patterns and Conventions

### Function Structure

**Public Functions** (exported):

- Location: `src/Public/Verb-Noun.ps1`
- Naming: `Verb-Noun` (approved verbs only)
- Must have comment-based help
- Must support pipeline input and `-WhatIf` for destructive operations

**Private Functions** (internal):

- Location: `src/Private/VerbNoun.ps1`
- Naming: descriptive; not exported
- Used to keep public APIs stable

---

### Error Handling (Recommended Pattern)

Use this simple pattern for all functions:

    try {
        $result = Invoke-Operation
    }
    catch {
        # Human-readable message
        Write-Verbose "$($MyInvocation.MyCommand) Operation failed: $_"
        # Full stack trace for debugging
        Write-Verbose "StackTrace: $($_.ScriptStackTrace)"
        # Preserve original exception
        throw $_
    }

**Notes:**

- Preserves exception type and stack trace
- Safe for nested function calls
- Verbose logging provides context without double logging
- Optional: append function name chain if deeper context is needed

---

### Parameter Validation

    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )

- Always validate inputs at function boundaries
- Use `[ValidateSet()]`, `[ValidateScript()]`, or `[ValidatePattern()]` when applicable

---

### Pipeline Support

- Use `begin {}`, `process {}`, `end {}` blocks for pipeline processing
- Collect results in `begin { $results = [System.Collections.Generic.List[object]]::new() }`
- Return results in `end { return $results }`

---

### Comment-Based Help Template

    function Verb-Noun {
        <#
        .SYNOPSIS
            One-line description

        .DESCRIPTION
            Detailed description

        .PARAMETER Name
            Description of parameter

        .EXAMPLE
            Verb-Noun -Name 'Test'

        .OUTPUTS
            Type returned

        .NOTES
            Additional notes
        #>
    }

---

## Testing Guidelines

- Every function must have a corresponding `.Tests.ps1` file
- Use Pester 5+ for unit tests
- Test **both success and failure scenarios**
- Mock external dependencies as needed
- Ensure code coverage ≥ 80%
- Do not bypass tests or analyzers

**Example Test Structure:**

    Describe 'Verb-Noun' {
        Context 'Parameter Validation' {
            It 'Should require mandatory parameters' { { Verb-Noun } | Should -Throw }
        }
        Context 'Functionality' {
            It 'Should return expected result' { 
                $result = Verb-Noun -Name 'Test'
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }

---

## CI/CD and Quality

- Ensure PSScriptAnalyzer passes with no errors
- Security scans must pass
- Automated pipelines should run tests and build checks on every pull request
- Maintain semantic versioning with proper commit messages

---

## Quick Reference for AI Agents

- Preserve **behavior, types, and stack traces**
- Always include **parameter validation**
- Use `[CmdletBinding()]` and `-WhatIf` support
- Throw original exceptions; log context in `Write-Verbose`
- Keep code **readable, maintainable, and auditable**
- Write tests for every new function
- Follow approved PowerShell verbs and naming conventions
- Use `begin/process/end` for pipeline support
- Do not write secrets or environment-specific values

---

## Example AI-Friendly Function Template

    function Get-Something {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory, ValueFromPipeline)]
            [ValidateNotNullOrEmpty()]
            [string]$Name
        )

        begin { Write-Verbose "Starting $($MyInvocation.MyCommand)" }

        process {
            try {
                # Implementation goes here
            }
            catch {
                Write-Verbose "$($MyInvocation.MyCommand) failed: $_"
                Write-Verbose "StackTrace: $($_.ScriptStackTrace)"
                throw $_
            }
        }

        end { Write-Verbose "Completed $($MyInvocation.MyCommand)" }
    }

---

✅ **Summary:**  

Follow this document when generating code in this repository. This ensures:

- Consistent, maintainable, and auditable code
- Proper error handling and logging
- Pipeline-friendly, tested, and secure functions
- AI agents generate **safe and production-ready** code without human rework
