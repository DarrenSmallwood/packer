################################################################################
##  File:  Install-Git.ps1
##  Team:  CI-Platform
##  Desc:  Install Git for Windows
################################################################################

Import-Module -Name ImageHelpers

choco install git -y --package-parameters= "/GitAndUnixToolsOnPath /WindowsTerminal /NoShellIntegration"
choco install github -y

Add-MachinePathItem "C:\Program Files\Git\mingw64\bin"
Add-MachinePathItem "C:\Program Files\Git\usr\bin"
Add-MachinePathItem "C:\Program Files\Git\bin"
exit 0
