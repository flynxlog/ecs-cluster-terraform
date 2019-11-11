provider "aws" {
  region     = "us-east-1"
  version    = "~>2.0"
  access_key = "AKIASB7ZCA7FAWNTQSFX"
  secret_key = "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"
}

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  name                = "every-five-minutes"
  description         = "Fires every five minutes"
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "check_foo_every_five_minutes" {
  rule      = aws_cloudwatch_event_rule.every_five_minutes.name
  target_id = "putfunc"
  arn       = "arn:aws:lambda:us-east-1:141719373770:function:putfunc"
}
