Describe 'PSRedFishClient basic' {
    It 'Module file exists' {
        Test-Path -Path (Resolve-Path "src/PSRedfishClient.psd1") | Should -BeTrue
    }

    <#    Context 'Functions exported' {
        BeforeAll { Import-Module (Resolve-Path "../src/PSRedfishClient") -Force }
        It 'Connect-Redfish is available' {
            Get-Command Connect-Redfish -CommandType Function | Should -Not -BeNullOrEmpty
        }

        It 'Get-RedfishResource is available' {
            Get-Command Get-RedfishResource -CommandType Function | Should -Not -BeNullOrEmpty
        }
    } #>
}
