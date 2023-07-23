
function Add-DevelopmentFolder {
    [CmdletBinding()]
    param (
        [string]$srcPath,
        [string]$icoPath   
    )
    
    $permIcoPath = "C:\AutoInstall"

    New-Item -ItemType Directory -Force -Path $srcPath

    $TargetDirectory = $srcPath

    New-Item -ItemType Directory -Force -Path $permIcoPath
    Copy-Item $icoPath -Destination $permIcoPath

    $DesktopIni = @"
[.ShellClassInfo]
IconResource=$permIcoPath\CODE.ico
"@

    If (Test-Path "$($TargetDirectory)\desktop.ini") {
        Write-Warning "The desktop.ini file already exists."
    }
    Else {
        #Create/Add content to the desktop.ini file
        Add-Content "$($TargetDirectory)\desktop.ini" -Value $DesktopIni
  
        #Set the attributes for $DesktopIni
  (Get-Item "$($TargetDirectory)\desktop.ini" -Force).Attributes = 'Hidden, System, Archive'

        #Finally, set the folder's attributes
  (Get-Item $TargetDirectory -Force).Attributes = 'ReadOnly, Directory'
    }

}