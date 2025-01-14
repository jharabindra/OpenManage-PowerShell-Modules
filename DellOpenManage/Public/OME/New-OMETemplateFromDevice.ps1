﻿using module ..\..\Classes\Device.psm1

function New-OMETemplateFromDevice {
<#
Copyright (c) 2018 Dell EMC Corporation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
#>

<#
.SYNOPSIS
    Create template from source device in OpenManage Enterprise
.DESCRIPTION
.PARAMETER Name
    String that will be assigned the name of the template
.PARAMETER Description
    String that will be assigned the description of the template
.PARAMETER Device
    Single Device object returned from Get-OMEDevice function
.PARAMETER Component
    Components to include in the template (Default="All", "iDRAC", "BIOS", "System", "NIC", "LifecycleController", "RAID", "EventFilters")
.PARAMETER Type
    Type of template to create (Default="Deployment", "Configuration")
    Deployment: Only 1 template assigned to a device, used with Virtual Identities
    Configuration: Many templates can be assigned to a device, used with Configuration Compliance
.PARAMETER Wait
    Wait for job to complete
.PARAMETER WaitTime
    Time, in seconds, to wait for the job to complete
.INPUTS
    None
.EXAMPLE
    New-OMETemplateFromDevice -Component "iDRAC", "BIOS" -Device $("37KP0ZZ" | Get-OMEDevice -FilterBy "ServiceTag") -Wait

    Create new deployment template from device
.EXAMPLE
    New-OMETemplateFromDevice -TemplateType "Configuration" -Component "iDRAC", "BIOS" -Device $("37KP0ZZ" | Get-OMEDevice -FilterBy "ServiceTag") -Wait
    
    Create new configuration template from device
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [Device]$Device,

    [Parameter(Mandatory=$false)]
    [String]$Name = "Template $((Get-Date).ToString('yyyyMMddHHmmss'))",

    [Parameter(Mandatory=$false)]
    [String]$Description,

    [Parameter(Mandatory=$false)]
    [ValidateSet("iDRAC", "BIOS", "System", "NIC", "LifecycleController", "RAID", "EventFilters", "All")]
    [String[]]$Component = @("All"),

    [Parameter(Mandatory=$false)]
    [ValidateSet("Deployment", "Configuration")]
    [String]$TemplateType = "Deployment",

    [Parameter(Mandatory=$false)]
    [Switch]$Wait,

    [Parameter(Mandatory=$false)]
    [int]$WaitTime = 3600
)

Begin {}
Process {
    if (!$(Confirm-IsAuthenticated)){
        Return
    }
    Try {
        if ($SessionAuth.IgnoreCertificateWarning) { Set-CertPolicy }
        $BaseUri = "https://$($SessionAuth.Host)"
        $Type        = "application/json"
        $Headers     = @{}
        $Headers."X-Auth-Token" = $SessionAuth.Token
        $TEMPLATE_TYPE_MAP = @{
            "Configuration" = 1;
            "Deployment" = 2
        }
        $TemplateUrl = $BaseUri + "/api/TemplateService/Templates"
        $TemplatePayload = '{
            "Name" : "Template From Device",
            "Description":"Template created from a source device",
            "TypeId" : 2,
            "ViewTypeId":2,
            "SourceDeviceId" : 25014,
            "Fqdds" : "EventFilters"
        }'
        $TemplatePayload = $TemplatePayload | ConvertFrom-Json
        $TemplatePayload.Name = $Name
        $TemplatePayload.Description = $Description
        $TemplatePayload.SourceDeviceId = $Device.Id
        $TemplatePayload.ViewTypeId = $TEMPLATE_TYPE_MAP[$TemplateType]
        $TemplatePayload.Fqdds = $Component -join ","
        $TemplatePayload = $TemplatePayload | ConvertTo-Json -Depth 6
        Write-Verbose $TemplatePayload
        $TemplateId = $null
        Write-Verbose "Creating Template..."
        $TemplateResponse = Invoke-WebRequest -Uri $TemplateUrl -Method Post -Body $TemplatePayload -ContentType $Type -Headers $Headers
        if ($TemplateResponse.StatusCode -eq 201) {
            $TemplateId = $TemplateResponse.Content | ConvertFrom-Json
            if ($Wait) {
                $TemplateStatus = $($TemplateId | Wait-OnTemplate -WaitTime $WaitTime)
                return $TemplateStatus
            }
        }
        return $TemplateId
    }
    Catch {
        Resolve-Error $_
    }
}

End {}

}

