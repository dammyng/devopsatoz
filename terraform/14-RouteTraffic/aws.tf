# Configure provider
provider "aws" {
  region = "us-east-1"
}

# Create target group
resource "aws_lb_target_group" "example" {
  name_prefix      = "example-tg-"
  port             = 80
  protocol         = "HTTP"
  vpc_id           = aws_vpc.example.id
  target_type      = "ip"
}

# Create listener
resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

# Create load balancer
resource "aws_lb" "example" {
  name               = "example-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.example.id]
  subnets            = aws_subnet.example.*.id
}
