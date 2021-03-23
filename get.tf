resource "aws_api_gateway_method" "process_payload_method_get" {
  rest_api_id      = aws_api_gateway_rest_api.apiGateway.id
  resource_id      = aws_api_gateway_resource.process_payload.id
  http_method      = "GET"
  authorization    = "AWS_IAM"
}

resource "aws_api_gateway_integration" "integration" {
   rest_api_id              = aws_api_gateway_rest_api.apiGateway.id
   resource_id              = aws_api_gateway_resource.process_payload.id
   http_method              = aws_api_gateway_method.process_payload_method_get.http_method
   integration_http_method  = "GET"
   type                     = "MOCK"
   uri                      = var.lambda_invoke_arn

   request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }

  request_templates = {
    "application/xml" = <<EOF
{
   "statusCode" : 200,
   "message" : "Healthy" 
}
EOF
  }
}
