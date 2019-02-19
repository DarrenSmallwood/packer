################################################################################
##  File:  Install-Snyk.ps1
##  Team:  CI-X
##  Desc:  Install Snyk.
################################################################################

Import-Module -Name ImageHelpers -Force

npm install -g snyk
