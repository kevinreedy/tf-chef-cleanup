provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "/Users/kreedy/.aws/credentials"
  profile                 = "success"
}

resource "aws_instance" "chef-node" {
  ami                    = "ami-a042f4d8"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-09604f23123a44a15"
  vpc_security_group_ids = ["sg-075d9a6da3fc6cfc2"]
  key_name               = "kreedy-aws"

  tags {
    Name = "kreedy_terraform_test"
  }

  provisioner "chef" {
    environment     = "_default"
    run_list        = ["recipe[test_cookbook]"]
    node_name       = "kreedy_terraform_test"
    server_url      = "https://chef.dayold.pizza/organizations/acme"
    recreate_client = true
    user_name       = "kreedy"
    user_key        = "${file("/Users/kreedy/.chef/kreedy.pem")}"
    version         = "14.10.9"
    ssl_verify_mode = ":verify_none"

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/Users/kreedy/.ssh/chef-aws")}"
    }
  }

  provisioner "local-exec" {
    when = "destroy"
    command = "knife node delete -y kreedy_terraform_test && knife client -y delete kreedy_terraform_test"
  }
}
