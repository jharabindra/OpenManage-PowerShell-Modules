$credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Global:OMEUsername, $(ConvertTo-SecureString -Force -AsPlainText $Global:OMEPassword)
Connect-OMEServer -Name $Global:OMEServer -Credentials $credentials -IgnoreCertificateWarning
Describe "Template" {
    BeforeEach {
        $DeviceServiceTag = "37KP0Q2"
    }
    Context "General" {
        It "Should return ALL templates" {
            Get-OMETemplate | Measure-Object | Select-Object -ExpandProperty Count | Should -BeGreaterThan 2
        }
    }
    Context "Deployment" {
        It ("Should create a deployment template from source device and return JobId"){
            $TemplateName = "TestDeploymentTemplate_FromDevice_$((Get-Date).ToString('yyyyMMddHHmmss'))"
            New-OMETemplateFromDevice -Name $TemplateName -Device $($DeviceServiceTag | Get-OMEDevice -FilterBy "ServiceTag") -Component "All" -Verbose | Should -BeGreaterThan 0
        }

        It ("Should create a new deployment template from XML string located in a file") {
            $xml = Get-Content -Path .\Tests\Data\Test01.xml | Out-String
            $TemplateNameFromFile = "TestDeploymentTemplate_FromFile_$((Get-Date).ToString('yyyyMMddHHmmss'))"
            New-OMETemplateFromFile -Name $TemplateNameFromFile -Content $xml -Wait -Verbose
            $TemplateNameFromFile | Get-OMETemplate -FilterBy "Name" | Select-Object -ExpandProperty Name | Should -Be $TemplateNameFromFile
            $TemplateNameFromFile | Get-OMETemplate -FilterBy "Name" | Select-Object -ExpandProperty ViewTypeId | Should -Be 2
        }

        It ("Should create a new deployment template from XML string") {
            $xml = '
            <SystemConfiguration>
                <Component FQDD="iDRAC.Embedded.1">
                    <Attribute Name="Users.12#UserName">testuser</Attribute>
                </Component>
            </SystemConfiguration>
            '
            $TemplateNameFromString = "TestDeploymentTemplate_FromString_$((Get-Date).ToString('yyyyMMddHHmmss'))"
            New-OMETemplateFromFile -Name $TemplateNameFromString -Content $xml -Wait -Verbose
            $TemplateNameFromString | Get-OMETemplate -FilterBy "Name" | Select-Object -ExpandProperty Name | Should -Be $TemplateNameFromString
            $TemplateNameFromString | Get-OMETemplate -FilterBy "Name" | Select-Object -ExpandProperty ViewTypeId | Should -Be 2
        }

        It "Should return all deployment templates" {
            "Deployment" | Get-OMETemplate -FilterBy "Type" | Measure-Object | Select-Object -ExpandProperty Count | Should -BeGreaterThan 1
        }
    }
    Context "Compliance" {
        It ("Should create a compliance template from source device and return JobId"){
            $TemplateName = "TestTemplate_FromDevice_$((Get-Date).ToString('yyyyMMddHHmmss'))"
            New-OMETemplateFromDevice -Name $TemplateName -TemplateType "Compliance" -Device $($DeviceServiceTag | Get-OMEDevice -FilterBy "ServiceTag") -Component "All" -Verbose | Should -BeGreaterThan 0
        }

        It ("Should create a new compliance template from XML string located in a file") {
            $xml = Get-Content -Path .\Tests\Data\Test01.xml | Out-String
            $TemplateNameFromFile = "TestComplianceTemplate_FromFile_$((Get-Date).ToString('yyyyMMddHHmmss'))"
            New-OMETemplateFromFile -Name $TemplateNameFromFile -TemplateType "Compliance" -Content $xml -Wait -Verbose
            $TemplateNameFromFile | Get-OMETemplate -FilterBy "Name" | Select-Object -ExpandProperty Name | Should -Be $TemplateNameFromFile
            $TemplateNameFromFile | Get-OMETemplate -FilterBy "Name" | Select-Object -ExpandProperty ViewTypeId | Should -Be 1
        }

        It ("Should create a new compliance template from XML string") {
            $xml = '
            <SystemConfiguration>
                <Component FQDD="iDRAC.Embedded.1">
                    <Attribute Name="Users.12#UserName">testuser</Attribute>
                </Component>
            </SystemConfiguration>
            '
            $TemplateNameFromString = "TestComplianceTemplate_FromString_$((Get-Date).ToString('yyyyMMddHHmmss'))"
            New-OMETemplateFromFile -Name $TemplateNameFromString -TemplateType "Compliance" -Content $xml -Wait -Verbose
            $TemplateNameFromString | Get-OMETemplate -FilterBy "Name" | Select-Object -ExpandProperty Name | Should -Be $TemplateNameFromString
            $TemplateNameFromString | Get-OMETemplate -FilterBy "Name" | Select-Object -ExpandProperty ViewTypeId | Should -Be 1
        }

        It "Should return all compliance templates" {
            "Compliance" | Get-OMETemplate -FilterBy "Type" | Measure-Object | Select-Object -ExpandProperty Count | Should -BeGreaterThan 1
        }

    }
}