provider "aws" {
  region = "us-east-1"

}

# resource "aws_instance" "test-terraform" {
#   ami="ami-0889a44b331db0194"
#   instance_type = "t2.micro"
#   tags = {
#     #Name = "test-terraform-fabs"
#   }
# }

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_function" "my_lambda_test" {
  function_name = "my_lambda_test"
  image_uri = "780370201175.dkr.ecr.us-east-1.amazonaws.com/lambdatest:3" 
  role          = aws_iam_role.lambda_role.arn
  package_type = "Image"
  
  timeout = 10

  memory_size = 128
}

resource "aws_cloudwatch_event_rule" "every_fifteen_minutes" {
  name                = "fifteen-minutes"
  description         = "runs every fifteen minutes"
  schedule_expression = "rate(15 minutes)"
}

resource "aws_cloudwatch_event_target" "invoke_lambda_every_fifteen_minutes" {
  rule      = aws_cloudwatch_event_rule.every_fifteen_minutes.name
  target_id = "invokeLambdaFunction"
  arn       = aws_lambda_function.my_lambda_test.arn
}