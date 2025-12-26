function Get-PSScriptModuleInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ModulePath
    )

    # Import the module manifest
    $moduleManifest = Import-PowerShellDataFile -Path (Join-Path -Path $ModulePath -ChildPath "$((Get-Item $ModulePath).BaseName).psd1")

    # Create a custom object to hold module information
    $moduleInfo = [PSCustomObject]@{
        Name         = $moduleManifest.ModuleName
        Version      = $moduleManifest.ModuleVersion
        Author       = $moduleManifest.Author
        Description  = $moduleManifest.Description
        RootModule   = $moduleManifest.RootModule
        Cmdlets      = @()
        Functions    = @()
        Variables    = @()
        Aliases      = @()
        Dependencies = $moduleManifest.RequiredModules
    }

    # Get exported cmdlets, functions, variables, and aliases
    $exportedItems = Get-Module -Name $moduleInfo.Name -ListAvailable | Select-Object -ExpandProperty ExportedCommands

    foreach ($item in $exportedItems) {
        switch ($item.CommandType) {
            'Cmdlet' { $moduleInfo.Cmdlets += $item.Name }
            'Function' { $moduleInfo.Functions += $item.Name }
            'Variable' { $moduleInfo.Variables += $item.Name }
            'Alias' { $moduleInfo.Aliases += $item.Name }
        }
    }

    return $moduleInfo
}