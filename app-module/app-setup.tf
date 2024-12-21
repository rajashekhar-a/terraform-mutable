resource "null_resource" "app-deploy" {
  count = length(local.PRIVATE_IPS)
  provisioner "remote-exec" {
    connection {
      host     = element(local.PRIVATE_IPS, count.index)
      user     = local.ssh_user
      password = local.ssh_pass
    }

    inline = [
      "ansible-pull -U https://github.com/rajashekhar-a/ansible.git roboshop-pull.yml -e ENV=${var.ENV} -e COMPONENT=${var.COMPONENT}"
    ]
  }
}
