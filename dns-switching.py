import json
import subprocess
import boto3

# Run terraform output -json and capture result
tf_output = subprocess.check_output(["terraform", "output", "-json"])
outputs = json.loads(tf_output)

hosted_zone_id = outputs["hosted_zone_id"]["value"]
alb_zone_id = outputs["alb_zone_id"]["value"]
alb_dns_name = outputs["alb_dns_name"]["value"]

route53 = boto3.client("route53")

response = route53.change_resource_record_sets(
    HostedZoneId=hosted_zone_id,  # update with your Id
    ChangeBatch={
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": "citytrust.com",
                    "Type": "A",
                    "SetIdentifier": "mumbai",
                    "Weight": 0,
                    "AliasTarget": {
                        "HostedZoneId": alb_zone_id,  # update with your zone id
                        "DNSName": alb_dns_name,
                        "EvaluateTargetHealth": True
                    }
                }
            }
        ]
    }
)