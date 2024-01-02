module "lambda_execution_role" {
  source = "../iam_role"
  assume_role_policy = {
    "Service" = ["lambda.amazonaws.com"]
  }
  role_name                = var.execution_role_name
  role_managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  policy_document          = var.execution_role_policy_document
}
