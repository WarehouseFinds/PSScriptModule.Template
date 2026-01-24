BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')
}

Describe 'ConvertToHumanReadableSize' {
    Context 'Parameter Validation' {

        It 'Should not accept negative values' {
            { ConvertToHumanReadableSize -Bytes -1 } | Should -Throw
        }

        It 'Should accept zero' {
            { ConvertToHumanReadableSize -Bytes 0 } | Should -Not -Throw
        }

        It 'Should accept maximum long value' {
            { ConvertToHumanReadableSize -Bytes ([long]::MaxValue) } | Should -Not -Throw
        }
    }

    Context 'Size Conversion' {
        It 'Should return "0 bytes" for zero input' {
            $result = ConvertToHumanReadableSize -Bytes 0
            $result | Should -Be '0 bytes'
        }

        It 'Should format bytes correctly' {
            $result = ConvertToHumanReadableSize -Bytes 512
            $result | Should -Be '512 bytes'
        }

        It 'Should convert to KB correctly' {
            $result = ConvertToHumanReadableSize -Bytes 1024
            $result | Should -Be '1.00 KB'
        }

        It 'Should convert to MB correctly' {
            $result = ConvertToHumanReadableSize -Bytes 1048576
            $result | Should -Be '1.00 MB'
        }

        It 'Should convert to GB correctly' {
            $result = ConvertToHumanReadableSize -Bytes 1073741824
            $result | Should -Be '1.00 GB'
        }

        It 'Should convert to TB correctly' {
            $result = ConvertToHumanReadableSize -Bytes 1099511627776
            $result | Should -Be '1.00 TB'
        }

        It 'Should format decimal places correctly' {
            $result = ConvertToHumanReadableSize -Bytes 1536
            $result | Should -Be '1.50 KB'
        }

        It 'Should round to two decimal places' {
            $result = ConvertToHumanReadableSize -Bytes 1555
            $result | Should -Match '^\d+\.\d{2} KB$'
        }
    }

    Context 'Largest Unit Selection' {
        It 'Should prefer larger units' {
            $result = ConvertToHumanReadableSize -Bytes (5GB + 500MB)
            $result | Should -Match 'GB'
            $result | Should -Not -Match 'MB'
        }

        It 'Should use bytes for values less than 1KB' {
            $result = ConvertToHumanReadableSize -Bytes 1023
            $result | Should -Be '1023 bytes'
        }
    }

    Context 'Edge Cases' {
        It 'Should handle 1 byte' {
            $result = ConvertToHumanReadableSize -Bytes 1
            $result | Should -Be '1 bytes'
        }

        It 'Should handle exactly 1KB boundary' {
            $result = ConvertToHumanReadableSize -Bytes 1024
            $result | Should -Be '1.00 KB'
        }

        It 'Should handle exactly 1MB boundary' {
            $result = ConvertToHumanReadableSize -Bytes (1024 * 1024)
            $result | Should -Be '1.00 MB'
        }

        It 'Should handle large TB values' {
            $result = ConvertToHumanReadableSize -Bytes (10 * 1TB)
            $result | Should -Be '10.00 TB'
        }
    }

    Context 'Return Type' {
        It 'Should return string type' {
            $result = ConvertToHumanReadableSize -Bytes 1024
            $result | Should -BeOfType [string]
        }

        It 'Should not return null' {
            $result = ConvertToHumanReadableSize -Bytes 0
            $result | Should -Not -BeNullOrEmpty
        }
    }
}
