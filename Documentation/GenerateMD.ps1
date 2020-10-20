using module ..\DellOpenManage\Classes\Baseline.psm1
using module ..\DellOpenManage\Classes\Catalog.psm1
using module ..\DellOpenManage\Classes\Repository.psm1
using module ..\DellOpenManage\Classes\Schedule.psm1
using module ..\DellOpenManage\Classes\ComponentCompliance.psm1
using module ..\DellOpenManage\Classes\Device.psm1
using module ..\DellOpenManage\Classes\Group.psm1
using module ..\DellOpenManage\Classes\SessionAuth.psm1
using module ..\DellOpenManage\Classes\Template.psm1
using module ..\DellOpenManage\Classes\TemplateAttribute.psm1
using module ..\DellOpenManage\Classes\NetworkPartition.psm1
using module ..\DellOpenManage\Classes\Job.psm1
using module ..\DellOpenManage\Classes\JobDetail.psm1

$module = "DellOpenManage"
Remove-Module $module
Import-Module $module
Import-Module platyPS

$FunctionList = @()
foreach ($cmdlet in (Get-Command -Module DellOpenManage)) { 
    $meta = @{
        'layout' = 'post';
        'author' = 'Trevor Squillario';
        'title' = $($cmdlet.Name);
        'category' = $($cmdlet.ModuleName).ToUpper();
        'tags' = 'OnlineHelp PowerShell';
    }
    $FunctionList += $cmdlet.Name
    New-MarkdownHelp -Command $cmdlet -OutputFolder .\Documentation\Functions -Metadata $meta -Force 
}

$IndexFile = "./Documentation/CommandReference.md"
$IndexText = ""
$IndexText += "# Functions"
$IndexText | Out-File -FilePath $IndexFile -Encoding ASCII
foreach ($Function in $FunctionList) {
    "- [$($Function)](Functions/$($Function).md)" | Add-Content $IndexFile
}

$ClassText = ""
$ClassText += "# Custom Types"
$ClassText | Add-Content $IndexFile
$folders = @('Classes')
foreach ($folder in $folders) {
    $folderPath = "$($pwd)\$($module)\$($folder)"
    if (Test-Path -Path $folderPath) {
        $ClassFiles = Get-ChildItem -Path $folderPath -Filter '*.psm1'
        foreach ($Class in $ClassFiles) {
            $ClassProperties = New-Object -TypeName $Class.BaseName | Get-Member -MemberType Property
            "## $($Class.BaseName)" | Add-Content $IndexFile
            foreach ($Property in $ClassProperties) { 
                "- $($Property.Name) ($($Property.Definition))" | Add-Content $IndexFile
            }
        }
    }    
}