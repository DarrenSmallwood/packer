################################################################################
##  File:  Install-Specflow.ps1
##  Team:  CI-X
##  Desc:  Install Specflow.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install specflow -y