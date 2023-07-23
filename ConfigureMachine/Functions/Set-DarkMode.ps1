function Set-DarkMode {
    [CmdletBinding()]
    param (
        $EnableDarkMode = $true
    )

    if ($EnableDarkMode) {
        # enable dark mode
        Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0
    }
    else {
        # disable dark mode
        Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 1
    }
}