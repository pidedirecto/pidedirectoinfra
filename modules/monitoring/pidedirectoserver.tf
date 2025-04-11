resource "aws_cloudwatch_log_metric_filter" "pidedirecto_server_api_error_count" {
  name           = "ApiErrorCount-${var.environment}"
  log_group_name = "/aws/lambda/letseatserver-${var.environment}-api"

  pattern = "{ $.logType = \"API_RESPONSE\" && $.error=\"*\" && $.apiEndpoint=\"*\" && $.api=\"*\" && $.facade NOT EXISTS }"

  metric_transformation {
    name      = "Api Error Count"
    namespace = "PideDirectoServer-${var.environment}"
    value     = "1"
    unit      = "Count"

    dimensions = {
      api         = "$.api"
      apiEndpoint = "$.apiEndpoint"
      error       = "$.error"
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "pidedirecto_server_api_count" {
  name           = "ApiCallCount-${var.environment}"
  log_group_name = "/aws/lambda/letseatserver-${var.environment}-api"
  pattern        = "{ $.logType = \"API_REQUEST\" && $.apiEndpoint=\"*\" && $.api=\"*\" && $.facade NOT EXISTS }"

  metric_transformation {
    name      = "Api Call Count (${var.environment})"
    namespace = "PideDirectoServer-${var.environment}"
    value     = 1
    unit      = "Count"

    dimensions = {
      api         = "$.api"
      apiEndpoint = "$.apiEndpoint"
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "pidedirecto_server_api_duration" {
  name           = "ApiDuration-${var.environment}"
  log_group_name = "/aws/lambda/letseatserver-${var.environment}-api"
  pattern        = "{ $.logType = \"API_RESPONSE\" && $.duration=\"*\" && $.apiEndpoint=\"*\" && $.api=\"*\" && $.facade NOT EXISTS }"

  metric_transformation {
    name      = "Api Duration (${var.environment})"
    namespace = "PideDirectoServer-${var.environment}"
    value     = "$.duration"
    unit      = "Milliseconds"
    dimensions = {
      api         = "$.api"
      apiEndpoint = "$.apiEndpoint"
      duration    = "$.duration"
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "pidedirecto_server_api_response_size" {
  name           = "ApiResponseSize-${var.environment}"
  log_group_name = "/aws/lambda/letseatserver-${var.environment}-api"
  pattern        = "{ $.logType = \"API_RESPONSE\" && $.responseSize=\"*\" && $.apiEndpoint=\"*\" && $.api=\"*\" && $.facade NOT EXISTS }"

  metric_transformation {
    name      = "Api Response Size (${var.environment})"
    namespace = "PideDirectoServer-${var.environment}"
    value     = "$.responseSize"
    unit      = "Bytes"
    dimensions = {
      api          = "$.api"
      apiEndpoint  = "$.apiEndpoint"
      responseSize = "$.responseSize"
    }
  }
}