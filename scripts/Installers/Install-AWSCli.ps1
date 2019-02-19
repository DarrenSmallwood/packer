################################################################################
##  File:  Install-AWSCli.ps1
##  Team:  CI-X
##  Desc:  Install Amazon Web Services cli.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install awscli -y
