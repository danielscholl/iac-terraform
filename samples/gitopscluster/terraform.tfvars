/*
.Synopsis
   Terraform Variable File
.DESCRIPTION
   This file holds the variables to be used with the application.
*/

name                = "gitops"
location            = "southcentralus"
randomization_level = 3
gitops_ssh_url      = "git@github.com:danielscholl/k8-gitops-manifests.git"