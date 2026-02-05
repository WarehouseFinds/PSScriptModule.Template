---
document type: cmdlet
external help file: PSScriptModule-Help.xml
HelpUri: https://github.com/YourUsername/PSScriptModule
Locale: en-US
Module Name: PSScriptModule
ms.date: 02/05/2026
PlatyPS schema version: 2024-05-01
title: Get-ModuleMetadata
---

# Get-ModuleMetadata

## SYNOPSIS

Retrieves metadata information from PowerShell module manifest files

## SYNTAX

### __AllParameterSets

```
Get-ModuleMetadata [-Path] <string[]> [-IncludeSize] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Reads and extracts metadata from PowerShell module manifest (.psd1) files,
including version, author, description, and exported functions.
Supports pipeline input for processing multiple modules.

## EXAMPLES

### EXAMPLE 1

Get-ModuleMetadata -Path ./MyModule/MyModule.psd1

Retrieves metadata from the specified module manifest file.

### EXAMPLE 2

Get-ChildItem -Path ./modules -Filter *.psd1 -Recurse | Get-ModuleMetadata

Processes multiple module manifests through the pipeline.

### EXAMPLE 3

Get-ModuleMetadata -Path ./MyModule -IncludeSize

Retrieves metadata and includes formatted file size information.

## PARAMETERS

### -IncludeSize

Include the file size of the module in the output

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

The path to the module manifest file (.psd1) or directory containing a manifest.
Accepts wildcards for batch processing.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases:
- FullName
- PSPath
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
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

### System.String
System.IO.FileInfo

{{ Fill in the Description }}

### System.String[]

{{ Fill in the Description }}

## OUTPUTS

### PSCustomObject
Returns objects with module metadata properties

{{ Fill in the Description }}

### System.Management.Automation.PSObject

{{ Fill in the Description }}

## NOTES

Validates manifest files before processing to ensure data integrity.
Uses fail-fast approach for invalid inputs.


## RELATED LINKS

- [](https://github.com/YourUsername/PSScriptModule)
