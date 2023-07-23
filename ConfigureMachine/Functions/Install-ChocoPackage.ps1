<#
.SYNOPSIS
    Install Piped in packages using the Chocolatey Framework
#>
function Install-ChocoPackage {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
    	[string] $pkgName
    )
    
    begin {
        Write-Verbose "Installing Choco packages.."
    }
    
    process {
        Write-Verbose "Installing $pkgName"
        choco install $pkgName -y
    }
    
    end {
        Write-Verbose "Choco packages installation complete"
    }
}

function Update-AllChocoPackages {
    [CmdletBinding()]
    param (
    )
    choco upgrade all -y 
}