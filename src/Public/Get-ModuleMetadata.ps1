function Get-ModuleMetadata {
    <#
    .SYNOPSIS
        Retrieves metadata information from PowerShell module manifest files

    .DESCRIPTION
        Reads and extracts metadata from PowerShell module manifest (.psd1) files,
        including version, author, description, and exported functions.
        Supports pipeline input for processing multiple modules.

    .PARAMETER Path
        The path to the module manifest file (.psd1) or directory containing a manifest.
        Accepts wildcards for batch processing.

    .PARAMETER IncludeSize
        Include the file size of the module in the output

    .EXAMPLE
        Get-ModuleMetadata -Path ./MyModule/MyModule.psd1

        Retrieves metadata from the specified module manifest file.

    .EXAMPLE
        Get-ChildItem -Path ./modules -Filter *.psd1 -Recurse | Get-ModuleMetadata

        Processes multiple module manifests through the pipeline.

    .EXAMPLE
        Get-ModuleMetadata -Path ./MyModule -IncludeSize

        Retrieves metadata and includes formatted file size information.

    .INPUTS
        System.String
        System.IO.FileInfo

    .OUTPUTS
        PSCustomObject
        Returns objects with module metadata properties

    .NOTES
        Validates manifest files before processing to ensure data integrity.
        Uses fail-fast approach for invalid inputs.

    .LINK
        https://github.com/YourUsername/PSScriptModule
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Metadata is conceptually singular')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Function returns PSCustomObject items from internal List collection')]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('FullName', 'PSPath')]
        [string[]]
        $Path,

        [Parameter()]
        [switch]
        $IncludeSize
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $results = [System.Collections.Generic.List[PSCustomObject]]::new()
    }

    process {
        foreach ($itemPath in $Path) {
            try {
                Write-Verbose "Processing path: $itemPath"

                # Fail fast: Validate path exists
                if (-not (Test-Path -Path $itemPath)) {
                    throw "Path does not exist: $itemPath"
                }

                # Resolve to manifest file
                $manifestPath = if ((Get-Item -Path $itemPath).PSIsContainer) {
                    # If directory, look for .psd1 file
                    $psd1Files = Get-ChildItem -Path $itemPath -Filter '*.psd1' -File
                    if ($psd1Files.Count -eq 0) {
                        throw "No module manifest (.psd1) file found in: $itemPath"
                    }
                    if ($psd1Files.Count -gt 1) {
                        throw "Multiple module manifest files found in: $itemPath. Specify exact file path."
                    }
                    $psd1Files[0].FullName
                } else {
                    # Fail fast: Validate file extension
                    if ([System.IO.Path]::GetExtension($itemPath) -ne '.psd1') {
                        throw "File must be a PowerShell module manifest (.psd1): $itemPath"
                    }
                    $itemPath
                }

                Write-Verbose "Reading manifest: $manifestPath"

                # Import and validate manifest
                $manifest = Test-ModuleManifest -Path $manifestPath -ErrorAction Stop

                # Build result object
                $metadata = [PSCustomObject]@{
                    Name              = $manifest.Name
                    Version           = $manifest.Version.ToString()
                    Author            = $manifest.Author
                    Description       = $manifest.Description
                    CompanyName       = $manifest.CompanyName
                    Copyright         = $manifest.Copyright
                    PowerShellVersion = $manifest.PowerShellVersion.ToString()
                    ExportedFunctions = $manifest.ExportedFunctions.Keys.Count
                    ExportedCmdlets   = $manifest.ExportedCmdlets.Keys.Count
                    Path              = $manifestPath
                }
                $metadata.PSObject.TypeNames.Insert(0, 'PSScriptModule.ModuleMetadata')

                # Add size information if requested
                if ($IncludeSize) {
                    $fileInfo = Get-Item -Path $manifestPath
                    $metadata | Add-Member -NotePropertyName 'SizeBytes' -NotePropertyValue $fileInfo.Length
                    $metadata | Add-Member -NotePropertyName 'FormattedSize' -NotePropertyValue (ConvertToHumanReadableSize -Bytes $fileInfo.Length)
                }

                $results.Add($metadata)
                Write-Verbose "Successfully processed: $($manifest.Name)"
            } catch {
                Write-Verbose "$($MyInvocation.MyCommand) Failed to process '$itemPath': $_"
                Write-Verbose "StackTrace: $($_.ScriptStackTrace)"
                throw $_
            }
        }
    }

    end {
        Write-Verbose "Completed $($MyInvocation.MyCommand). Processed $($results.Count) module(s)."
        return $results
    }
}
