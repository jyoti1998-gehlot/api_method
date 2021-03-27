resource "aws_api_gateway_resource" "healthcheck" {
  parent_id   = aws_api_gateway_rest_api.panda.root_resource_id
  path_part   = "healthcheck"
  rest_api_id = aws_api_gateway_rest_api.panda.id
}

resource "aws_api_gateway_method" "panda1" {
  rest_api_id          = aws_api_gateway_rest_api.panda.id
  resource_id          = aws_api_gateway_resource.healthcheck.id
  http_method          = "GET"
  authorization        = "NONE"
}


resource "aws_api_gateway_integration" "integration" {
  
  rest_api_id             = aws_api_gateway_rest_api.panda.id
  resource_id             = aws_api_gateway_resource.healthcheck.id
  http_method             = aws_api_gateway_method.panda1.http_method
  type                    = "MOCK"
  
  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/xml" = <<EOF
{
   
   "statusCode" : 200,
   "message" : "Healthy"
}
EOF
  }
}

resource "aws_api_gateway_deployment" "panda1" {
  rest_api_id = aws_api_gateway_rest_api.panda.id

  triggers = {
   
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.healthcheck.id,
      aws_api_gateway_method.panda1.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}


