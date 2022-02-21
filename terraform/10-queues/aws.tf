provider "aws" {
  region = "us-west-2"
}

resource "aws_sqs_queue" "queue" {
  name = "my-queue"

  tags = {
    Environment = "Production"
  }
}
