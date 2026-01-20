# 🛠️ Development Workflow

## Creating New Functions

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

## 🎓 Learning Resources

- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-development-guidelines)
- [Pester Documentation](https://pester.dev/)
- [PSScriptAnalyzer Rules](https://github.com/PowerShell/PSScriptAnalyzer)
- [Semantic Versioning](https://semver.org/)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
