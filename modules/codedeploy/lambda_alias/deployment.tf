locals {
  appspec = {
    version = "0.0"
    Resources = [{
      MyFunction = {
        Type = "AWS::Lambda::Function"
        Properties = {
          Name           = var.function_name
          Alias          = var.alias_name
          CurrentVersion = var.current_version
          TargetVersion  = var.target_version
        }
      }
    }]
  }
  appspec_content = replace(jsonencode(local.appspec), "\"", "\\\"")
  appspec_sha256  = sha256(jsonencode(local.appspec))

  codedeploy_script = <<EOF
if [ ${var.current_version} -ne ${var.target_version} ]
then 
ID=$(aws deploy create-deployment \
  --region ${var.aws_region} \
  --profile ${var.aws_profile} \
  --application-name ${var.codedeploy_app_name} \
  --deployment-group-name ${var.codedeploy_deployment_group_name} \
  --revision '{"revisionType": "AppSpecContent", "appSpecContent": {"content": "${local.appspec_content}", "sha256": "${local.appspec_sha256}"}}' \
  --output text \
  --query '[deploymentId]')

STATUS=$(aws deploy get-deployment \
  --region ${var.aws_region} \
  --profile ${var.aws_profile} \
  --deployment-id $ID \
  --output text \
  --query '[deploymentInfo.status]')

while [[ $STATUS == "Created" || $STATUS == "InProgress" || $STATUS == "Pending" || $STATUS == "Queued" || $STATUS == "Ready" ]]; do
  echo "Codedeploy status: $STATUS..."
  STATUS=$(aws deploy get-deployment \
  --region ${var.aws_region} \
  --profile ${var.aws_profile} \
  --deployment-id $ID \
  --output text \
  --query '[deploymentInfo.status]')
  sleep 5
done
fi
EOF
}


resource "null_resource" "run_codedeploy" {
  triggers = {
    current_version = var.current_version
    target_version  = var.target_version
  }

  provisioner "local-exec" {
    # Only trigger deploy when lambda version is updated
    command     = local.codedeploy_script
    interpreter = ["/bin/bash", "-c"]
  }
}

