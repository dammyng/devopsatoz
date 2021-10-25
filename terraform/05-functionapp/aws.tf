provider "aws" {
  region = "us-west-2"
}

resource "aws_lambda_function" "function_app" {
  filename         = "function_app.zip"
  function_name    = "function_app"
  role             = "arn:aws:iam::ACCOUNT_ID:role/lambda-role"
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  source_code_hash = "${base64sha256(file("function_app.zip"))}"
}
