terraform {
  backend "s3" {
    bucket         = "terraform-backend-avilinux85"
    key            = "test/terraform.tfstate"
    dynamodb_table = "dynamodb-remotestate"
    region         = "ap-south-1"
  }
}


data "aws_ami" "ami-mumbai" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "lockec2" {
  ami           = data.aws_ami.ami-mumbai.id
  instance_type = "t2.micro"
  tags = {
    Name = upper("lock-mumbai")
  }
}


resource "aws_eip" "eip_sg" {
  vpc = true
}

resource "time_sleep" "wait_40_seconds" {
  create_duration = "40s"
}
