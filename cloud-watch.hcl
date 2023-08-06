resource "aws_cloudwatch_event_rule" "invoke_lambda_rule" {
  name = "invoke-lambda-rule"

  event_pattern = jsonencode({
    source = ["aws.ec2"],
    detail_type = ["EC2 Instance State-change Notification"],
    detail = {
      state = ["running"]
    }
  })
}

resource "aws_cloudwatch_event_target" "invoke_lambda_target" {
  rule = aws_cloudwatch_event_rule.invoke_lambda_rule.name
  target_id = "invoke-lambda-target"
  arn = aws_lambda_function.my_lambda_function.arn
}
