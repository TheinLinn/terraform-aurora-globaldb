import boto3

route53 = boto3.client("route53")

response = route53.change_resource_record_sets(
    HostedZoneId="ZXXXXXXXXXXXXX",  # update with your Id
    ChangeBatch={
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": "citytrust.com",
                    "Type": "A",
                    "SetIdentifier": "singapore",
                    "Weight": 0,
                    "AliasTarget": {
                        "HostedZoneId": "ALB_ZONE_ID",  # update with your zone id
                        "DNSName": "dc-alb.amazonaws.com",
                        "EvaluateTargetHealth": True
                    }
                }
            }
        ]
    }
)