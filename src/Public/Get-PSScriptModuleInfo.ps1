function Get-PSScriptModuleInfo
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ModulePath
    )

    try
    {
        $moduleManifest = Import-PowerShellDataFile -Path $ModulePath
        $moduleInfo = [PSCustomObject]@{
            ModuleVersion = $moduleManifest.ModuleVersion
            GUID          = $moduleManifest.GUID
            Author        = $moduleManifest.Author
            Description   = $moduleManifest.Description
            CompanyName   = $moduleManifest.CompanyName
        }

        return $moduleInfo
    }
    catch
    {
        throw "$($MyInvocation.MyCommand.Name): Failed to get module info from $ModulePath. $_"
    }
}