import boto3

rds = boto3.client('rds')

rds.failover_global_cluster(
    GlobalClusterIdentifier= 'aws_rds_global_cluster.globaldb.id',
   # TargetDbClusterIdentifier='arn:aws:rds:ap-northeast-1:ACCOUNT:cluster:dr-cluster'
)