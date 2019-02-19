################################################################################
##  File:  Install-Nuget.ps1
##  Team:  CI-X
##  Desc:  Install nuget command line.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install nuget.commandline -y
