# 🔧 Build Tasks

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
