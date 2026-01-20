# Generating Help

This project uses [PlatyPS](https://github.com/PowerShell/platyPS) to generate extensive documentation:

- Markdown help files for each command
- MAML files for PowerShell's Get-Help
- Module-level documentation
- Example sections for usage

```powershell

# Generate markdown and MAML help files
Invoke-Build Export-CommandHelp
```

Help files are generated in two formats:

1. **Markdown** (`.md`) - Stored in `docs/help/` for web/GitHub viewing
1. **MAML** (`.xml`) - Stored in module's `en-US/` folder for `Get-Help` command

## Using Help in PowerShell

```powershell
# Import your module
Import-Module ./build/out/PSScriptModule/PSScriptModule.psd1

# View help
Get-Help Get-PSScriptModuleInfo -Full
Get-Help Get-PSScriptModuleInfo -Examples
Get-Help Get-PSScriptModuleInfo -Online
```