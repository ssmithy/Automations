

function Add-CustomPowerPlan {
    [CmdletBinding()]
    param (
        # Power Plan Name
        [Parameter(Mandatory)]
        [string]
        $PlanName,
        # Screen Timeout AC
        [Parameter(Mandatory)]
        [int]
        $ScreenTimeoutAC,
        # Sleep Timeout AC
        [Parameter(Mandatory)]
        [int]
        $SleepTimeoutAC,
        # Screen Timeout DC
        [Parameter(Mandatory)]
        [int]
        $ScreenTimeoutDC,
        # Sleep Timeout DC
        [Parameter(Mandatory)]
        [int]
        $SleepTimeoutDC,
        # Delete All Other Plans 
        $DeleteOtherPlans = $false
    )
    Add-NewPowerPlanAndActivate $PlanName
    Set-PowerTimeouts $ScreenTimeoutAC $ScreenTimeoutDC $SleepTimeoutAC $SleepTimeoutDC

    if ($DeleteOtherPlans) {
        Remove-AllPowerPlans
    }
}

function Add-NewPowerPlanAndActivate {
    param (
        [string] $PlanName
    )
    $newGuid = $(New-Guid)
    $currentPlan = powercfg /GetActiveScheme
    
    [regex]$regex = "\w{8}-\w{4}-\w{4}-\w{4}-\w{12}"
    $planMatch = $regex.Match($currentPlan)  
    
    Write-Verbose 'Duplicating power plan..'
    powercfg /DuplicateScheme $planMatch $newGuid

    powercfg /SetActive $newGuid

    powercfg /ChangeName $newGuid "$PlanName Power" "Custom plan created by PS Script."
}


function Set-PowerTimeouts {
    [CmdletBinding()]
    param (
        [int] $ScreenTimeoutAC,
        [int] $ScreenTimeoutDC,
        [int] $SleepTimeoutAC,
        [int] $SleepTimeoutDC
    )
    
    ## set some values on the power plan
    Write-Verbose 'Setting AC Options..'
    powercfg /Change monitor-timeout-ac $ScreenTimeoutAC
    powercfg /Change hibernate-timeout-ac $SleepTimeoutAC
    powercfg /Change standby-timeout-ac $SleepTimeoutAC

    Write-Verbose 'Setting DC Options..'
    powercfg /Change monitor-timeout-dc $ScreenTimeoutDC
    powercfg /Change hibernate-timeout-dc $SleepTimeoutDC
    powercfg /Change standby-timeout-dc $SleepTimeoutDC
}

function Remove-AllPowerPlans {
    [CmdletBinding()]
    param (
    )
    Write-Verbose "Deleting All Power Schemes.."

    $powerSchemes = powercfg list

    [regex]$regex = "\w{8}-\w{4}-\w{4}-\w{4}-\w{12}"
    $planMatches = $regex.Matches($powerSchemes)
    Write-Verbose $planMatches 
    
    foreach ($schemeId in $planMatches) {
        Write-Verbose "Deleting: $schemeId"
        powercfg /d $schemeId
    }   
}

### monitor-timeout-ac minutes
### monitor-timeout-dc minutes
### disk-timeout-ac minutes
### disk-timeout-dc minutes
### standby-timeout-ac minutes
### standby-timeout-dc minutes
### hibernate-timeout-ac minutes
### hibernate-timeout-dc minutes
### Setting any value to 0 will set the timeout=Never
### AC settings are used when the system is on AC power. DC settings on battery power.