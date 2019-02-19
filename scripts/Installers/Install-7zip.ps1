################################################################################
##  File:  Install-7zip.ps1
##  Team:  CI-X
##  Desc:  Install 7zip.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install 7zip -y
