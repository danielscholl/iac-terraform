module "ssh_key" {
  source                = "../"
  name                  = "gitops_rsa"
  ssh_public_key_path   = "./.ssh"
  public_key_extension  = ".pub"
  chmod_command         = "chmod 600 %v"
}