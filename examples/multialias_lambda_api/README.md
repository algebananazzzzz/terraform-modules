```json
{
    "version": "0.0",
    "Resources": [
        {
            "MyFunction": {
                "Type": "AWS::Lambda::Function",
                "Properties": {
                    "Name": "",
                    "Alias": "DEV",
                    "CurrentVersion": "1",
                    "TargetVersion": "2"
                }
            }
        }
    ]
}
```

```shell
if [ $currentversion -ne $targetversion ]
then 
ID=$(aws deploy create-deployment \
  --region $AWS_REGION \
  --profile $AWS_PROFILE \
  --application-name $codedeploy_app_name \
  --deployment-group-name $codedeploy_deployment_group_name \
  --revision '{"revisionType": "AppSpecContent", "appSpecContent": {"content": $appspec_content}}' \
  --output text \
  --query '[deploymentId]')

STATUS=$(aws deploy get-deployment \
  --region $AWS_REGION \
  --profile $AWS_PROFILE \
  --deployment-id $ID \
  --output text \
  --query '[deploymentInfo.status]')

while [[ $STATUS == "Created" || $STATUS == "InProgress" || $STATUS == "Pending" || $STATUS == "Queued" || $STATUS == "Ready" ]]; do
  echo "Codedeploy status: $STATUS..."
  STATUS=$(aws deploy get-deployment \
  --region $AWS_REGION \
  --profile $AWS_PROFILE \
  --deployment-id $ID \
  --output text \
  --query '[deploymentInfo.status]')
  sleep 5
done
fi
```