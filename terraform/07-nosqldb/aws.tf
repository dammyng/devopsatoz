provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table" "example" {
  name           = "example_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "hash_key"
  range_key      = "range_key"
  point_in_time_recovery {
    enabled = true
  }
  tags = {
    Environment = "prod"
  }
}
