function GetModuleId {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ModulePath
    )

    # Import the module manifest to get the module GUID
    $moduleManifest = Import-PowerShellDataFile -Path $ModulePath
    return $moduleManifest.Guid
}