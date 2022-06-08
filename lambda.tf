locals {
  lambda_function_name    = "${local.site_fqdn_safe}-lambda-edge-rewrite"
  lambda_function_payload = "${path.module}/lambda_payload.zip"
}

data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/lambda/edge_rewrite/rewrite.js"
  output_path = local.lambda_function_payload
}

resource "aws_lambda_function" "lambda_edge_rewrite" {
  publish  = true

  filename      = local.lambda_function_payload
  function_name = local.lambda_function_name
  role          = aws_iam_role.lambda_rewrite.arn
  handler       = "rewrite.handler"

  runtime = "nodejs12.x"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_edge_rewrite
  ]

  tags = var.extra_tags
}

resource "aws_iam_role" "lambda_rewrite" {
  name = local.lambda_function_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "lambdaassume"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
        }
      },
    ]
  })

  tags = var.extra_tags
}

resource "aws_cloudwatch_log_group" "lambda_edge_rewrite" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = 14

  tags = var.extra_tags
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${local.site_fqdn_safe}-lambda-rewrite-logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_rewrite.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
