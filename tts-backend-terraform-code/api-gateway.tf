# Create a HTTP API Gateway
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "http-api"
  protocol_type = "HTTP"
  //this bloc is added to resolve cors pbm
  //1 cors_configuration {
  // 2 allow_origins = ["*"]
  //allow_methods = ["POST", "GET", "OPTIONS"]
  //allow_headers = ["content-type"]
  // 3 allow_methods = ["*"]
  //allow_headers = ["Content-Type", "Authorization", "X-Amz-Date", "X-Api-Key", "X-Amz-Security-Token"]
  // 4 allow_headers = ["*"]
  // 5 max_age       = 0
  //6 }

}
# Create a stage for the created API Gateway
resource "aws_apigatewayv2_stage" "test" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "test"
  auto_deploy = true

  # The fields of the API Gateway logs
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway_log_group.arn
    format          = jsonencode({ "requestId" : "$context.requestId", "ip" : "$context.identity.sourceIp", "requestTime" : "$context.requestTime", "httpMethod" : "$context.httpMethod", "routeKey" : "$context.routeKey", "status" : "$context.status", "protocol" : "$context.protocol", "responseLength" : "$context.responseLength" })
  }
}
# Create cloudwatch log group for the API Gateway logs
resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "/aws/apigateway/APIGatewayLogs"
  retention_in_days = 30
}

# The invoke URL that will be used to test the solution
output "invokeURL" {
  value = aws_apigatewayv2_stage.test.invoke_url
}
