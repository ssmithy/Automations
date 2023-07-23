<#
.SYNOPSIS
    Returns a configuration object given the passed in path and json file values
#>
function Read-Config {
    [CmdletBinding()]
    param (
        # Directory where the configuration file resides
        [Parameter(Mandatory = $true)]
        [string]
        $ConfigPath,
        # Config filename
        [Parameter(Mandatory = $true)]
        [string]
        $ConfigFileName
    )
    
    ## build the full filepath, pull the config file
    ## parse to an object
    $fullPathToFile = Join-Path -Path $ConfigPath -ChildPath $ConfigFileName
    Write-Verbose "Config file path: $fullPathToFile"

    $fileExists = Test-Path $fullPathToFile
    Write-Verbose "Config file exists: $fileExists"
 
    if($fileExists -eq $false){
        throw "Configuration file could not be found."
    }

    $configContent = Get-Content $fullPathToFile

    $configObj = $configContent | ConvertFrom-Json
    Write-Verbose "Parsed config obj: $configObj"

    ## return the full config from the file
    return $configObj
}