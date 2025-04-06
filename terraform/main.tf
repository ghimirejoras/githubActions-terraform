# main.tf 


data "external" "check_key" {
  program = ["bash", "${path.module}/../scripts/check_key.sh"]
  query = {
    key_name = var.key_name
  }
}



resource "aws_key_pair" "new_key_pair" {
  count      = data.external.check_key.result["exists"] == "true" ? 0 : 1
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

locals {
  final_key_name = data.external.check_key.result["exists"] == "true" ? var.key_name : aws_key_pair.new_key_pair[0].key_name
}

resource "aws_instance" "nginx_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = local.final_key_name
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  # user_data = file("${path.module}/../scripts/user_data.sh")

  tags = {
    Name = "NginxServer"
  }

  provisioner "file" {
    source      = var.filelocation_prtkey
    destination = var.destination


    connection {

      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(var.filelocation_prtkey)
      timeout     = "15m"
    }
  }

  # Provisioner for Ansible

  provisioner "file" {
    source      = "${path.module}/../ansible/playbook.yml"
    destination = "/tmp/playbook.yml"

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(var.filelocation_prtkey)
      timeout     = "15m"
    }
  }

  /*
  This process expose prt key so we need to use local-exec or any secure method or make this process well secure and execute ansible in ec2
  Ansible runs in local machine and connect to ec2 instance using ssh key and 
  ansible playbook is executed in local machine
  */


  provisioner "remote-exec" {
    inline = [

      "sudo usermod -aG sudo ubuntu",

      "sudo apt update -y",

      "sudo apt install python3 python3-pip -y",

      "sudo apt install ansible -y",

      "export ANSIBLE_HOST_KEY_CHECKING=False",

      "chmod 600 ${var.destination}",

      "echo '[webservers]' > /tmp/hosts",
      # "echo '${self.public_ip}' >> /tmp/hosts",

      "echo '${self.public_ip} ansible_ssh_private_key_file=${var.destination} ansible_user=ubuntu' >> /tmp/hosts",

      "ansible-playbook /tmp/playbook.yml -i /tmp/hosts"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(var.filelocation_prtkey)
      timeout     = "12m"
    }
  }


}

resource "aws_eip" "nginx_eip" {
  instance = aws_instance.nginx_instance.id
  domain   = "vpc"

  tags = {
    Name = "NginxEIP"
  }
}



