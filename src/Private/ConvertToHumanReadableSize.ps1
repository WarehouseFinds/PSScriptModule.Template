function ConvertToHumanReadableSize {
    <#
    .SYNOPSIS
        Converts byte size to human-readable format

    .DESCRIPTION
        Internal helper function that converts file sizes in bytes to
        human-readable format (KB, MB, GB, TB).

    .PARAMETER Bytes
        The size in bytes to convert

    .EXAMPLE
        ConvertToHumanReadableSize -Bytes 1024
        Returns: "1.00 KB"

    .EXAMPLE
        ConvertToHumanReadableSize -Bytes 1048576
        Returns: "1.00 MB"

    .OUTPUTS
        System.String

    .NOTES
        Private function - not exported from module
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(0, [long]::MaxValue)]
        [long]
        $Bytes
    )

    # Fail fast: Handle zero bytes
    if ($Bytes -eq 0) {
        return '0 bytes'
    }

    # Fail fast: Validate non-negative
    if ($Bytes -lt 0) {
        throw "Bytes parameter must be non-negative. Received: $Bytes"
    }

    $sizes = @(
        @{ Name = 'TB'; Value = 1TB }
        @{ Name = 'GB'; Value = 1GB }
        @{ Name = 'MB'; Value = 1MB }
        @{ Name = 'KB'; Value = 1KB }
    )

    foreach ($size in $sizes) {
        if ($Bytes -ge $size.Value) {
            $value = $Bytes / $size.Value
            return '{0:N2} {1}' -f $value, $size.Name
        }
    }

    # Less than 1 KB
    return "$Bytes bytes"
}
