<#
.SYNOPSIS
    Install Piped in packages using the VS Code extension installer
#>
function Install-VSCodeExtension {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
    	[string] $extName
    )
    
    begin {
        Write-Verbose "Installing VS Code Extensions.."
    }
    
    process {
        Write-Verbose "Installing $extName"
        code --install-extension $extName
    }
    
    end {
        Write-Verbose "VS Code Extensions installation complete"
    }
}