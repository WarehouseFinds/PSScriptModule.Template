---
document type: cmdlet
external help file: PSScriptModule-Help.xml
HelpUri: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-powershelldatafile
Locale: en-US
Module Name: PSScriptModule
ms.date: 12/30/2025
PlatyPS schema version: 2024-05-01
title: Get-PSScriptModuleInfo
---

# Get-PSScriptModuleInfo

## SYNOPSIS

Retrieves information from a PowerShell script module manifest file.

## SYNTAX

### __AllParameterSets

```
Get-PSScriptModuleInfo [-ModulePath] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

The Get-PSScriptModuleInfo function reads a PowerShell script module manifest file (.psd1)
and extracts key information such as ModuleVersion, GUID, Author, Description, and CompanyName.

## EXAMPLES

### EXAMPLE 1

Get-PSScriptModuleInfo -ModulePath "C:\Modules\MyModule\MyModule.psd1"
Retrieves module information from the specified module manifest file.

## PARAMETERS

### -ModulePath

The file path to the PowerShell script module manifest (.psd1) from which to retrieve information.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This function requires PowerShell 5.0 or later.
Ensure the module manifest file exists and is accessible.
Errors during import will be caught and reported.
The function returns a custom object with module information.


## RELATED LINKS

- [](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-powershelldatafile)
