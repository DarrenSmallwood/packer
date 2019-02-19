################################################################################
##  File:  Install-VS2015.ps1
##  Team:  CI-Build
##  Desc:  Install Visual Studio 2015
################################################################################

Import-Module -Name ImageHelpers -Force

choco install visualstudio2015community -y --execution-timeout 7200

# Find the version of VS installed for this instance
$regKey = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$installedApplications = Get-ItemProperty -Path $regKey
$VisualStudioVersion = ($installedApplications | Where-Object { $_.DisplayName -and $_.DisplayName.toLower().Contains("visual studio community") } | Select-Object -First 1).DisplayVersion
Write-Host "Visual Studio version" $VisualStudioVersion "installed"

exit $exitCode
