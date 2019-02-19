################################################################################
##  File:  Install-mRemoteNG.ps1
##  Team:  CI-X
##  Desc:  Install mRemoteNG.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install mremoteng -y
