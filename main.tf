provider "aws" {
  region  = "us-east-1"
  version = "2.59"
}

resource "aws_key_pair" "us-east-1-key" {
  key_name   = "state_class_key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami           = "ami-0947d2ba12ee1ff75"
}


terraform {
  required_version = "0.11.14"

  backend "s3" {
    bucket = "davron-test"
    dynamodb_table = "test_table"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
