# Provider configuration
provider "aws" {
  region = "us-west-2"
}

# Resource configuration
resource "aws_instance" "mysql_server" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "my_key"
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  tags = {
    Name = "mysql-server"
  }

  # User data for installing MySQL
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install mysql-server -y
              EOF
}

resource "aws_security_group" "mysql_sg" {
  name_prefix = "mysql-sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
