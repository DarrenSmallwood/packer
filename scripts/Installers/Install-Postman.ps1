################################################################################
##  File:  Install-Postman.ps1
##  Team:  CI-X
##  Desc:  Install Postman.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install postman -y
