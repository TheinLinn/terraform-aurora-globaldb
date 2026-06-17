import boto3

ecs = boto3.client('ecs', region_name='ap-northeast-1')

def lambda_handler(event, context):

    ecs.update_service(
        cluster='dr-cluster',
        service='dr-service',
        desiredCount=2
    )

    return {
        'statusCode': 200
    }