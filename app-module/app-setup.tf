resource "null_resource" "app-deploy" {
  count = length(local.PRIVATE_IPS)
  triggers = {
    abc = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      host     = element(local.PRIVATE_IPS, count.index)
      user     = local.ssh_user
      password = local.ssh_pass
    }

    inline = [
      "yum install python3.12-devel python3.12-pip -y",
      "pip3.12 install ansible ansible-core==2.16 botocore boto3 python-jenkins",
      "ansible-pull -U https://github.com/rajashekhar-a/ansible.git roboshop-pull.yml -e ENV=${var.ENV} -e COMPONENT=${var.COMPONENT} -e APP_VERSION=${var.APP_VERSION} -e NEXUS_USER=${var.NEXUS_USER} -e NEXUS_PASS=${var.NEXUS_PASS}"
    ]
  }
}
