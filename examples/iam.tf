
module "iam_policy" {
  source = "./modules/iam_policy"
  policy_document_statements = {
    "testRolePolicy" = {
      "actions" = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      "effect"    = "Allow"
      "resources" = ["arn:aws:logs:*:*:*"]
      "conditions" = {
        "ArnLike" = {
          "context_variable" = "aws:SourceArn"
          "values"           = ["arn:aws:logs:*:*"]
        }
      }
    }
  }
}

module "iam_role" {
  source                   = "./modules/iam_role"
  role_name                = "LambdaRoleName"
  role_managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  assume_role_policy = {
    "Service" : ["lambda.amazonaws.com"]
  }
  policy_document = {
    "statements" = { "testRolePolicy" = {
      "actions" = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      "effect"    = "Allow"
      "resources" = ["arn:aws:logs:*:*:*"]
      "conditions" = {
        "ArnLike" = {
          "context_variable" = "aws:SourceArn"
          "values"           = ["arn:aws:logs:*:*"]
        }
      }
    } }
  }
}
