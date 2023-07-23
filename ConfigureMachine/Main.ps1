<#
.SYNOPSIS
    Main.ps1

    Set Log output mode
    Import functions
    Load config
    Install Software
    Configure Power Settings
    Set Theme
    Create Development Folders
#>

## Dev config
$VerbosePreference = 'Continue'
# $VerbosePreference = 'SilentlyContinue'

## Load Functions
. .\Functions\Read-Config.ps1
. .\Functions\Install-ChocoPackage.ps1
. .\Functions\Set-PowerTimeouts.ps1
. .\Functions\Set-DarkMode.ps1
. .\Functions\Add-DevelopmentFolder.ps1
. .\Functions\Install-VSCodeExtension.ps1

## Get configuration values
$config = Get-Configuration -ConfigPath $PSScriptRoot -ConfigFileName "config.json"

## if set in config, install Chocolatey Packages
if ($config.Chocolatey.Enabled -eq [bool]::TrueString) {
    Write-Verbose "Chocolatey Install Enabled"
    $config.Chocolatey.Packages | Install-ChocoPackage
}

$config.VSCode.Extensions | Install-VSCodeExtension

## Configure Power Settings
$userName = $config.User.Name
$planName = "$userName's Plan"
$scrnAc = $config.PowerSettings.ScreenTimeoutAC
$scrnDc = $config.PowerSettings.ScreenTimeoutDC
$slpAc = $config.PowerSettings.SleepTimeoutAC
$slpDc = $config.PowerSettings.SleepTimeoutDC
$deletePlans = $config.PowerSettings.DeleteOtherPlans

Add-CustomPowerPlan $PlanName $scrnAc $slpAc $scrnDc $slpDc -DeleteOtherPlans $deletePlans

## Set Dark Mode
$enableDarkMode = $config.Themes.DarkMode
Set-DarkMode -EnableDarkMode $enableDarkMode

## Create Source folder, move the icon to C:\AutoInstall, set the source folder to it
$srcPath = Join-Path -Path $config.Development.Root -ChildPath $config.Development.SourceFolderName
$icoPath = "$PSScriptRoot\Assets\CODE.ico"

Add-DevelopmentFolder $srcPath $icoPath