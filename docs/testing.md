# 🧪 Testing

## Running Tests

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

## Test Output

All test results are saved to `test-results/` directory:

- `unit-tests.xml` - Pester test results (NUnit XML)
- `code-coverage.xml` - Code coverage report (Cobertura)
- `static-code-analysis.xml` - PSScriptAnalyzer results
- `code-injection.xml` - InjectionHunter security scan results
