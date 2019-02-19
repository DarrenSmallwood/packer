################################################################################
##  File:  Install-jdk8.ps1
##  Team:  CI-X
##  Desc:  Install java development kit 8.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install jdk8 -y
