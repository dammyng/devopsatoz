provider "aws" {
  region = "us-west-2"
}

resource "aws_eip" "example" {
  vpc = true
}
