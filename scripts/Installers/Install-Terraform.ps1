################################################################################
##  File:  Install-Terraform.ps1
##  Team:  CI-X
##  Desc:  Install Terraform.
################################################################################

Import-Module -Name ImageHelpers -Force

choco install terraform -y