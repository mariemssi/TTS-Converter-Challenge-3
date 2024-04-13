# Lambda and API Gateway integration

resource "aws_apigatewayv2_integration" "apigatewaytolambda" {
  api_id = aws_apigatewayv2_api.api_gateway.id

  integration_uri  = aws_lambda_function.texttospeech.invoke_arn
  integration_type = "AWS_PROXY"
}

resource "aws_apigatewayv2_route" "get_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /TextToSpeechConverter"
  target    = "integrations/${aws_apigatewayv2_integration.apigatewaytolambda.id}"
}

# Grants API Gateway permissions to invoke the Lambda function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.texttospeech.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}
