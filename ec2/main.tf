provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]
}

resource "aws_key_pair" "new_key" {
  key_name   = "test_new_bastion"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "centos7" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t3.micro"
  key_name      = "${aws_key_pair.new_key.key_name}"

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/id_rsa")}"
      host        = "${self.public_ip}"
    }

    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
    ]
  }

  tags = {
    Name = "testvms"
  }
}
