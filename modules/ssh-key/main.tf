##############################################################
# This module allows the creation of an SSH Key
##############################################################

locals {
  public_key_filename  = "${var.ssh_public_key_path}/${var.name}${var.public_key_extension}"
  private_key_filename = "${var.ssh_public_key_path}/${var.name}${var.private_key_extension}"
}

resource "null_resource" "mkdir" {
  provisioner "local-exec" {
    command = <<EOF
      mkdir -p ${var.ssh_public_key_path}
    EOF
  }
}

resource "tls_private_key" "default" {
  depends_on = [null_resource.mkdir]
  algorithm = var.ssh_key_algorithm
}

resource "local_file" "public_key_openssh" {
  depends_on = [tls_private_key.default]
  content    = tls_private_key.default.public_key_openssh
  filename   = local.public_key_filename
}

resource "local_file" "private_key_pem" {
  depends_on = [tls_private_key.default]
  content    = tls_private_key.default.private_key_pem
  filename   = local.private_key_filename
}

resource "null_resource" "chmod" {
  count      = var.chmod_command != "" ? 1 : 0
  depends_on = [local_file.private_key_pem]

  provisioner "local-exec" {
    command = format(var.chmod_command, local.private_key_filename)
  }
}