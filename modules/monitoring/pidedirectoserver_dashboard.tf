resource "aws_cloudwatch_dashboard" "pidedirecto_api_dashboard" {
  dashboard_name = "PideDirectoServer-API-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type  = "metric",
        x     = 0,
        y     = 0,
        width = 6,
        height = 6,
        properties = {
          metrics = [
            [
              {
                expression = "SELECT COUNT(\"Api Error Count\") FROM SCHEMA(\"PideDirectoServer-prod\", api,apiEndpoint,error) GROUP BY api"
                label      = ""
                id         = "q1"
                stat       = "Sum"
                region     = "${var.aws_region}"
                period     = 300
              }
            ]
          ],
          renderingProperties = {
            treatMissingData = "zero"
          },
          view                 = "timeSeries",
          connectDataPoints    = true,
          stacked              = false,
          region               = "${var.aws_region}",
          stat                 = "Sum",
          period               = 300,
          title                = "API Errors",
          yAxis = {
            left = {
              showUnits = false,
              min       = 0
            },
            right = {
              showUnits = false
            }
          },
          liveData             = false,
          start                = "-PT3H",
          setPeriodToTimeRange = true
        }
      }
    ]
  })

}
