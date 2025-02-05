# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0]() - 2022-03-16
### Changed
- Changed the way commandlets exit when authentication fails. Previously all commandlets would stop script execution if not authenticated which isn't a PowerShell best practice. If you would like to maintain this behavior use the -ErrorAction Stop on the Connect-OMEServer or any commandlet. https://devblogs.microsoft.com/scripting/handling-errors-the-powershell-way/#erroraction-parameter

### Fixed
- Disconnect-OMEServer checks if auth token exists before trying to remove auth session

## [2.3.8]() - 2022-03-11
### Added
- Examples/DiscoverAddToStaticGroup.ps1 will run a Discovery, create a static group and add the devices to the group

### Fixed
- Fixed column ordering in Invoke-OMEReport to properly match Report
- Fixed filtering with paged results in Get-OMEDevice. OME does not automatically add the filter parameters to @odata.nextLink 

## [2.3.7]() - 2022-02-16
### Added
- Copy-OMETemplate

## [2.3.4]() - 2022-02-08
### Added
- Remove-OMETemplate

### Fixed
- Fixed output in Invoke-OMEReport to allow saving to a file or variable

## [2.3.3]() - 2021-09-16

### Fixed
- Added support for OME 3.5+ and the -UseAllProtocols parameter on New-OMEDiscovery ([Issue #4](https://github.com/dell/OpenManage-PowerShell-Modules/issues/4))

## [2.3.2]() - 2021-09-16

### Fixed
- Fixed issue with -SetTrapDestination parameter on New-OMEDiscovery ([Issue #4](https://github.com/dell/OpenManage-PowerShell-Modules/issues/4))

## [2.3.1]() - 2021-09-14
### Added
- Migrated scripts from https://github.com/dell/OpenManage-Enterprise/tree/master/PowerShell
- Get-OMEAuditLog 
- Get-OMEWarranty
- Get-OMEAlert
- Get-OMEUser
- New-OMEUser
- Get-OMEIdentityPool
- Get-OMEIdentityPoolUsage
- New-OMEIdentityPool
- New-OMENetwork
- Get-OMENetwork
- Update-OMEFirmwareDUP
- Edit-OMESecurityBanner
- New-OMESupportAssistGroup
- Get-OMESupportAssistGroup
- Edit-OMESupportAssistGroup
- Remove-OMESupportAssistGroup
- Get-OMESupportAssistCase
- New-OMEMcmGroup
- Invoke-OMEMcmGroupAddMember
- Invoke-OMEMcmGroupAssignBackupLead
- Invoke-OMEMcmGroupRetireLead
- Get-OMEMXDomain

### Changed
- Changed Invoke-OMETemplateDeploy to use SecureString for -NetworkBootSharePassword
- Added -UseAllProtocols parameter to New-OMEDiscovery ([Issue #4](https://github.com/dell/OpenManage-PowerShell-Modules/issues/4))

### Fixed
- Fixed Set-CertPolicy to allow multiple Connect-OME within script ([Issue #2](https://github.com/dell/OpenManage-PowerShell-Modules/issues/2))
- Fixed Set-OMEPowerState ([Issue #3](https://github.com/dell/OpenManage-PowerShell-Modules/issues/3))

## [2.2.2]() - 2021-06-25
### Fixed
- Invoke-OMEInventoryRefresh added -Wait parameter

## [2.2.1]() - 2021-06-25
### Added
- Invoke-OMEJobRun new commandlet
- Invoke-OMEFirmwareBaselineRefresh new commandlet
- Invoke-OMEConfigurationCheck renamed to Invoke-OMEConfigurationBaselineRefresh

## [2.2.0]() - 2021-06-24
### Added
- OME 3.6.1 testing completed
- New-OMEGroup new commandlet
- Edit-OMEGroup new commandlet
- Remove-OMEGroup new commandlet
- Invoke-OMEInventoryRefresh new commandlet

## [2.1.0]() - 2021-05-13
### Added
- New-OMEConfigurationBaseline new commandlet
- Get-OMEConfigurationBaseline new commandlet
- Get-OMEConfigurationCompliance new commandlet
- Update-OMEConfiguration new commandlet
- Invoke-OMEProfileUnassign new commandlet
- Invoke-OMEConfigurationBaselineRefresh new commandlet

### Fixed
- New-OMETemplateFromDevice updated to support creation of Configuration templates
- New-OMETemplateFromFile updated to support creation of Configuration templates
- Get-OMETemplate added ability to get Deployment or Configuration templates

## [2.0.0]() - 2021-05-03
### Fixed
- Bumped minimum required OpenManage Enterprise version to 3.4
- Edit-OMEDiscovery new module to edit discovery jobs
- New-OMEDiscovery added ability to schedule job at a later date, added support for REDFISH discovery protocol
- New-OMEFirmwareBaseline refactored -Wait to  poll the completion status instead of a predefined sleep
- Get-OMEFirmwareCompliance modified -UpdateAction "All" to include components that have versions equal to that of the baseline

## [1.0.0]() - 2020-11-10
### Fixed
- Added Get-OMEDeviceNetworkDetail to show IP and Mac Address for quick export
- Modified Get-OMEDeviceDetail and removed the mapping for InventoryType. Specify the actual value instead of an abbreviated version

