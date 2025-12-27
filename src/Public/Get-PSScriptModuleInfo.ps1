function Get-PSScriptModuleInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ModulePath
    )

    # Import the module manifest
    $moduleManifest = Import-PowerShellDataFile -Path $ModulePath 
    # Create a custom object to hold module information
    $moduleInfo = [PSCustomObject]@{
        ModuleVersion = $moduleManifest.ModuleVersion
        GUID          = $moduleManifest.GUID
        Author        = $moduleManifest.Author
        Description   = $moduleManifest.Description
        Company       = $moduleManifest.Company
    }

    return $moduleInfo
}