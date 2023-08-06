resource "aws_apigatewayv2_api" "my_api" {
  name          = "my-api"
  protocol_type = "HTTP"
}

resource "aws_lambda_permission" "apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = aws_apigatewayv2_api.my_api.execution_arn
}

resource "aws_apigatewayv2_integration" "my_integration" {
  api_id                 = aws_apigatewayv2_api.my_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.my_lambda_function.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "my_route" {
  api_id    = aws_apigatewayv2_api.my_api.id
  route_key = "ANY /myresource"
  target    = "integrations/${aws_apigatewayv2_integration.my_integration.id}"
}

resource "aws_apigatewayv2_stage" "my_stage" {
  api_id      = aws_apigatewayv2_api.my_api.id
  name        = "$default"
  auto_deploy = true
}
