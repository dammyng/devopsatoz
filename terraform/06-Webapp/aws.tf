provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name = "example-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo '<h1>Welcome to the Example Web App!</h1>' | sudo tee /var/www/html/index.html"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  tags = {
    Name = "example-instance"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }

  depends_on = [
    aws_security_group.allow_http,
  ]
}

resource "aws_security_group" "allow_http" {
  name_prefix = "allow-http"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
