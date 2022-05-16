provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "load_balancer" {
  name_prefix = "load-balancer"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "load_balancer" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    "subnet-0f9e4b48ef0cbea6d",
    "subnet-0e74eef6de76b6b93",
    "subnet-0c5d5f82c5d2568ec"
  ]

  security_groups = [
    aws_security_group.load_balancer.id
  ]

  tags = {
    Name = "load-balancer"
  }
}

resource "aws_lb_target_group" "target_group" {
  name_prefix = "target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0de3839a20fbb0cb5"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
}
