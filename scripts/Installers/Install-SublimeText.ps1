################################################################################
##  File:  Install-SublimeText.ps1
##  Team:  CI-X
##  Desc:  Install sublime text 3.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install sublimetext3 -y
#choco install sublimetext3.packagecontrol -y