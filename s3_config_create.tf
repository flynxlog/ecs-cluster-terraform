resource "aws_s3_bucket" "sitespeed_config" {
  bucket = "escssconfiglogs"
  acl    = "public-read"

  tags {
    Name        = "sitespeed-config"
    Environment = "Dev"
  }
}

# bucket policy
resource "aws_s3_bucket_policy" "sitespeed_policy" {
  bucket = "${aws_s3_bucket.sitespeed_config.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "SITESPEEDCONFIGBUCKET",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::escssconfiglogs/*"

    }
  ]
}
POLICY
}

# Create a lambda function that will upload the config file
resource "aws_iam_role" "iam_s3_ssconfig" {
  name = "ss_config_upload"

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

resource "aws_lambda_function" "s3_config_load" {
  filename = "configUpload.zip"
  function_name = "ss_config_upload"
  role = "${aws_iam_role.iam_s3_ssconfig.arn}"
  handler = "config_upload.lambda_handler"
  runtime = "python3.7"
  source_code_hash = "${base64sha256(file("configUpload.zip"))}"

}

resource "aws_iam_role_policy" "lambda-cloudwatch-log-group" {
  name = "sitespeed-log-group"
  role = "${aws_iam_role.iam_s3_ssconfig.name}"
  policy = "${data.aws_iam_policy_document.cloudwatch-log-group-lambda.json}"
}

data "aws_iam_policy_document" "cloudwatch-log-group-lambda" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:::*",
    ]
  }
}

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name                = "every-five-minutes"
  description         = "Fires every five minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "check_SS_every_five_minutes" {
  rule      = "${aws_cloudwatch_event_rule.every_five_minutes.name}"
  target_id = "ss_config_upload"
  arn       = "${aws_lambda_function.s3_config_load.arn}"
}
