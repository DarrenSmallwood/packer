################################################################################
##  File:  Install-Packer.ps1
##  Team:  CI-X
##  Desc:  Install Packer.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install packer -y
