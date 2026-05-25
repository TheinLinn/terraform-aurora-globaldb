resource "aws_cloudwatch_metric_alarm" "replication_lag" {
  alarm_name          = "aurora-globaldb-replication-lag"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "AuroraGlobalDBReplicationLag"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 1000

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.primary.cluster_identifier
  }
}