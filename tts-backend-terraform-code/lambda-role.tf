# Defines an IAM role that specifies the permissions for the Lambda function.
# This role grants access to CloudWatch Logs to write logs and to Polly for text translation.

resource "aws_iam_role" "lambda_exec" {
  name = "texttospeech_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Creates an IAM policy with the necessary permissions for the Lambda function.
# Note: In production, permissions should be more restrictive.
resource "aws_iam_policy" "iam_policy_for_lambda" {

  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
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
   },
   {
      "Effect": "Allow",
      "Action": "polly:*",
      "Resource": "*"
    }
]
}
EOF
}

# Attaches the IAM policy to the IAM role.
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

