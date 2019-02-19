################################################################################
##  File:  Install-StyleCopExtensionForVS.ps1
##  Team:  CI-X
##  Desc:  Install stylecop extension for Visual Studio.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install stylecop-vsix -y