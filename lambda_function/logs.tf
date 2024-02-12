resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.logs_retention_in_days
}
