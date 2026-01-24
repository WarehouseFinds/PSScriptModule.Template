BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')

    # Dot source the private function
    . (Join-Path -Path $PSScriptRoot -ChildPath '../Private/ConvertToHumanReadableSize.ps1')
}

Describe 'Get-ModuleMetadata' {
    Context 'Parameter Validation' {

        It 'Should not accept null or empty Path' {
            { Get-ModuleMetadata -Path $null } | Should -Throw
            { Get-ModuleMetadata -Path '' } | Should -Throw
        }

        It 'Should accept Path from pipeline' {
            Mock Test-Path { $true }
            Mock Get-Item {
                [PSCustomObject]@{
                    PSIsContainer = $false
                    FullName      = 'test.psd1'
                }
            }
            Mock Test-ModuleManifest {
                [PSCustomObject]@{
                    Name              = 'TestModule'
                    Version           = [version]'1.0.0'
                    Author            = 'Test Author'
                    Description       = 'Test'
                    CompanyName       = 'Test Company'
                    Copyright         = 'Test Copyright'
                    PowerShellVersion = [version]'7.0'
                    ExportedFunctions = @{}
                    ExportedCmdlets   = @{}
                }
            }

            { 'test.psd1' | Get-ModuleMetadata } | Should -Not -Throw
        }
    }

    Context 'Path Resolution' {
        It 'Should throw when path does not exist' {
            Mock Test-Path { $false }

            { Get-ModuleMetadata -Path 'nonexistent.psd1' } | Should -Throw '*does not exist*'
        }

        It 'Should throw when file is not a .psd1 file' {
            Mock Test-Path { $true }
            Mock Get-Item {
                [PSCustomObject]@{
                    PSIsContainer = $false
                    FullName      = 'test.txt'
                }
            }

            { Get-ModuleMetadata -Path 'test.txt' } | Should -Throw '*must be a PowerShell module manifest*'
        }

        It 'Should throw when directory has no .psd1 files' {
            Mock Test-Path { $true }
            Mock Get-Item {
                [PSCustomObject]@{ PSIsContainer = $true }
            }
            Mock Get-ChildItem { @() }

            { Get-ModuleMetadata -Path './empty' } | Should -Throw '*No module manifest*'
        }

        It 'Should throw when directory has multiple .psd1 files' {
            Mock Test-Path { $true }
            Mock Get-Item {
                [PSCustomObject]@{ PSIsContainer = $true }
            }
            Mock Get-ChildItem {
                @(
                    [PSCustomObject]@{ FullName = 'module1.psd1' }
                    [PSCustomObject]@{ FullName = 'module2.psd1' }
                )
            }

            { Get-ModuleMetadata -Path './multiple' } | Should -Throw '*Multiple module manifest*'
        }
    }

    Context 'Metadata Extraction' {
        BeforeEach {
            Mock Test-Path { $true }
            Mock Get-Item {
                [PSCustomObject]@{
                    PSIsContainer = $false
                    FullName      = 'TestModule.psd1'
                    Length        = 1024
                }
            }
            Mock Test-ModuleManifest {
                [PSCustomObject]@{
                    Name              = 'TestModule'
                    Version           = [version]'1.2.3'
                    Author            = 'Test Author'
                    Description       = 'A test module'
                    CompanyName       = 'Test Company'
                    Copyright         = '(c) 2026 Test'
                    PowerShellVersion = [version]'7.0'
                    ExportedFunctions = @{
                        'Get-Something' = $null
                        'Set-Something' = $null
                    }
                    ExportedCmdlets   = @{}
                }
            }
        }

        It 'Should return module metadata object' {
            $result = Get-ModuleMetadata -Path 'TestModule.psd1'

            $result | Should -Not -BeNullOrEmpty
            $result.Name | Should -Be 'TestModule'
            $result.Version | Should -Be '1.2.3'
            $result.Author | Should -Be 'Test Author'
            $result.Description | Should -Be 'A test module'
        }

        It 'Should include exported function count' {
            $result = Get-ModuleMetadata -Path 'TestModule.psd1'

            $result.ExportedFunctions | Should -Be 2
        }

        It 'Should include path in output' {
            $result = Get-ModuleMetadata -Path 'TestModule.psd1'

            $result.Path | Should -Be 'TestModule.psd1'
        }

        It 'Should have correct type name' {
            $result = Get-ModuleMetadata -Path 'TestModule.psd1'

            $result.PSObject.TypeNames[0] | Should -Be 'PSScriptModule.ModuleMetadata'
        }
    }

    Context 'IncludeSize Parameter' {
        BeforeEach {
            Mock Test-Path { $true }
            Mock Get-Item {
                [PSCustomObject]@{
                    PSIsContainer = $false
                    FullName      = 'TestModule.psd1'
                    Length        = 2048
                }
            }
            Mock Test-ModuleManifest {
                [PSCustomObject]@{
                    Name              = 'TestModule'
                    Version           = [version]'1.0.0'
                    Author            = 'Test'
                    Description       = 'Test'
                    CompanyName       = 'Test'
                    Copyright         = 'Test'
                    PowerShellVersion = [version]'7.0'
                    ExportedFunctions = @{}
                    ExportedCmdlets   = @{}
                }
            }
            Mock ConvertToHumanReadableSize { '2.00 KB' }
        }

        It 'Should not include size by default' {
            $result = Get-ModuleMetadata -Path 'TestModule.psd1'

            $result.PSObject.Properties.Name | Should -Not -Contain 'SizeBytes'
            $result.PSObject.Properties.Name | Should -Not -Contain 'FormattedSize'
        }

        It 'Should include size when IncludeSize is specified' {
            $result = Get-ModuleMetadata -Path 'TestModule.psd1' -IncludeSize

            $result.SizeBytes | Should -Be 2048
            $result.FormattedSize | Should -Be '2.00 KB'
        }

        It 'Should call ConvertToHumanReadableSize with correct bytes' {
            $result = Get-ModuleMetadata -Path 'TestModule.psd1' -IncludeSize

            Should -Invoke ConvertToHumanReadableSize -Exactly 1 -ParameterFilter { $Bytes -eq 2048 }
        }
    }

    Context 'Pipeline Support' {
        BeforeEach {
            Mock Test-Path { $true }
            Mock Get-Item {
                [PSCustomObject]@{
                    PSIsContainer = $false
                    FullName      = $args[0]
                }
            }
            Mock Test-ModuleManifest {
                param($Path)
                [PSCustomObject]@{
                    Name              = [System.IO.Path]::GetFileNameWithoutExtension($Path)
                    Version           = [version]'1.0.0'
                    Author            = 'Test'
                    Description       = 'Test'
                    CompanyName       = 'Test'
                    Copyright         = 'Test'
                    PowerShellVersion = [version]'7.0'
                    ExportedFunctions = @{}
                    ExportedCmdlets   = @{}
                }
            }
        }

        It 'Should process multiple modules from pipeline' {
            $results = 'Module1.psd1', 'Module2.psd1', 'Module3.psd1' | Get-ModuleMetadata

            $results.Count | Should -Be 3
            $results[0].Name | Should -Be 'Module1'
            $results[1].Name | Should -Be 'Module2'
            $results[2].Name | Should -Be 'Module3'
        }
    }

    Context 'Error Handling' {
        It 'Should throw and write error on invalid manifest' {
            Mock Test-Path { $true }
            Mock Get-Item {
                [PSCustomObject]@{
                    PSIsContainer = $false
                    FullName      = 'BadModule.psd1'
                }
            }
            Mock Test-ModuleManifest { throw 'Invalid manifest' }

            { Get-ModuleMetadata -Path 'BadModule.psd1' -ErrorAction Stop } | Should -Throw
        }

        It 'Should write verbose messages' {
            Mock Test-Path { $true }
            Mock Get-Item {
                [PSCustomObject]@{
                    PSIsContainer = $false
                    FullName      = 'TestModule.psd1'
                }
            }
            Mock Test-ModuleManifest {
                [PSCustomObject]@{
                    Name              = 'TestModule'
                    Version           = [version]'1.0.0'
                    Author            = 'Test'
                    Description       = 'Test'
                    CompanyName       = 'Test'
                    Copyright         = 'Test'
                    PowerShellVersion = [version]'7.0'
                    ExportedFunctions = @{}
                    ExportedCmdlets   = @{}
                }
            }

            $verboseOutput = Get-ModuleMetadata -Path 'TestModule.psd1' -Verbose 4>&1

            $verboseOutput | Should -Not -BeNullOrEmpty
            $verboseOutput -join ' ' | Should -Match 'Starting'
            $verboseOutput -join ' ' | Should -Match 'Completed'
        }
    }
}
