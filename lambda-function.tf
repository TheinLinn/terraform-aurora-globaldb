# Lambda IAM Role
/*# If not exist lambda role, create role
resource "aws_iam_role" "lambda_role" {
  name = "failover-role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "lambda.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}*/

#If already exist lambda role, use existing role
data "aws_iam_role" "lambda_role" {
  name = "dr-failover-role"
}


# Lambda Policy
# If not exist lambda role, create role
# >> resource "aws_iam_role_policy" "lambda_policy" {

#If already exist lambda role, use existing role
data "aws_iam_policy" "lambda_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  /*  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ecs:UpdateService",
          "rds:SwitchoverGlobalCluster",
          "rds:FailoverGlobalCluster",
          "rds:DescribeGlobalClusters"
        ]

        Resource = "*"
      }
    ]
  })*/
}
# lambda role and policy attachment
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = data.aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.lambda_policy.arn
}
# lambda policy for S3 get object
resource "aws_iam_role_policy" "lambda_inline" {
  name = "lambda-inline-policy"
  role = data.aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:GetObject"]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::mybucket/*"
    }]
  })
}


# Lambda Function
resource "aws_lambda_function" "failover" {

  function_name = "dr-failover"

  role = data.aws_iam_role.lambda_role.arn

  runtime = "python3.12"

  handler = "failover.lambda_handler"

  filename = "${path.module}/lambda/failover.zip"
}

# SNS to Lambda Subscription
resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.dr_failover.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.failover.arn
}

# Lambda Permission
resource "aws_lambda_permission" "sns" {

  statement_id = "AllowSNS"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.failover.function_name

  principal = "sns.amazonaws.com"

  source_arn = aws_sns_topic.dr_failover.arn
}
