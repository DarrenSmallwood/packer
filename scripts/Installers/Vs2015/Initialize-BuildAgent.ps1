################################################################################
##  File:  Initialize-VM.ps1
##  Team:  CI-Platform
##  Desc:  VM initialization script, machine level configuration
################################################################################

function Disable-InternetExplorerESC {
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 -Force
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 -Force
    Stop-Process -Name Explorer -Force -ErrorAction SilentlyContinue
    Write-Host "IE Enhanced Security Configuration (ESC) has been disabled."
}

function Disable-InternetExplorerWelcomeScreen {
    $AdminKey = "HKLM:\Software\Policies\Microsoft\Internet Explorer\Main"
    New-Item -Path $AdminKey -Value 1 -Force
    Set-ItemProperty -Path $AdminKey -Name "DisableFirstRunCustomize" -Value 1 -Force
    Write-Host "Disabled IE Welcome screen"
}

function Disable-UserAccessControl {
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000 -Force
    Write-Host "User Access Control (UAC) has been disabled."
}

function Load-DefaultUserRegistry {
    reg load HKU\temphive c:\users\default\ntuser.dat
    Write-Host "Default user registry loaded"
}

function Update-IEJavaSettings {
    Write-Output "Updating Java settings in IE"
    If (!(Test-Path "registry::HKU\temphive\Software\MicroSoft\Windows\CurrentVersion\Internet Settings\Zones\3")) {
        New-Item -Path "registry::HKU\temphive\Software\MicroSoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Force | Out-Null
    }
    Set-ItemProperty -path "registry::HKU\temphive\Software\MicroSoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Name "1405" -Type DWord -Value 0
}

function Show-AllDrives {
    Set-ItemProperty -Path "registry::HKU\temphive\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type DWord -Value 1
    Write-Host "Show all drives in this PC"
}
    
function Show-HiddenFilesAndFolders {
    Set-ItemProperty -Path "registry::HKU\temphive\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Type DWord -Value 1
    Write-Host "Hidden files and folders now displayed"
}
    
function Show-FileExtensions {
    Set-ItemProperty -Path "registry::HKU\temphive\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type DWord -Value 0      
    Write-Host "All file extensions will be shown"
}
    
# Set taskbar buttons to show labels and never combine
Function Set-TaskbarCombineNever {
    Write-Output "Setting taskbar buttons to never combine..."
    Set-ItemProperty -Path "registry::HKU\temphive\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarGlomLevel" -Type DWord -Value 2
    Set-ItemProperty -Path "registry::HKU\temphive\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarGlomLevel" -Type DWord -Value 2
}

function Unload-DefaultUserRegistry {
    [gc]::collect()
    sleep 5
    reg unload HKU\temphive
}

Import-Module -Name ImageHelpers -Force

Write-Host "Setup PowerShellGet"
Install-PackageProvider NuGet -MinimumVersion 2.8.5.201 -Force
Import-PackageProvider NuGet -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name PowerShellGet -Force

Write-Host "Disable Antivirus"
Set-MpPreference -DisableRealtimeMonitoring $true

# Disable Windows Update
$AutoUpdatePath = "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
If (Test-Path -Path $AutoUpdatePath) {
    Set-ItemProperty -Path $AutoUpdatePath -Name NoAutoUpdate -Value 1
    Write-Host "Disabled Windows Update"
}
else {
    Write-Host "Windows Update key does not exist"
}

# Disable Server Manager
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask
Write-Host "Server manager disabled"

Write-Host "Disable UAC"
Disable-UserAccessControl

Write-Host "Disable IE Welcome Screen"
Disable-InternetExplorerWelcomeScreen

Write-Host "Disable IE ESC"
Disable-InternetExplorerESC

Write-Host "Loading default user registry"
Load-DefaultUserRegistry

Write-Host "Updating internet explorer java settings for CRM"
Update-IEJavaSettings

Write-Host "Setting this PC to show all drives by default"
Show-AllDrives

Write-Host "Setting explorer to show hidden files and folders"
Show-HiddenFilesAndFolders

Write-Host "Setting explorer to show all file extensions"
Show-FileExtensions

Write-Host "Updating task bar to never combine"
Set-TaskbarCombineNever

Write-Host "Unloading default user registry"
Unload-DefaultUserRegistry

Write-Host "Install chocolatey"
$chocoExePath = 'C:\ProgramData\Chocolatey\bin'

if ($($env:Path).ToLower().Contains($($chocoExePath).ToLower())) {
    Write-Host "Chocolatey found in PATH, skipping install..."
    Exit
}

# Add to system PATH
$systemPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
$systemPath += ';' + $chocoExePath
[Environment]::SetEnvironmentVariable("PATH", $systemPath, [System.EnvironmentVariableTarget]::Machine)

# Update local process' path
$userPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
if ($userPath) {
    $env:Path = $systemPath + ";" + $userPath
}
else {
    $env:Path = $systemPath
}

# Run the installer
Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Turn off confirmation
choco feature enable -n allowGlobalConfirmation