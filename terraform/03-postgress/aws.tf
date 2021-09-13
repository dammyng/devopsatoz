provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "postgres" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "postgres"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get -y install postgresql postgresql-contrib
              sudo systemctl start postgresql
              sudo systemctl enable postgresql
              EOF

  vpc_security_group_ids = [aws_security_group.postgres.id]
}

resource "aws_security_group" "postgres" {
  name_prefix = "postgres"
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
