/*# Monitor Replica Lag
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
}*/
/*
# Monitor DB connection health check
resource "aws_cloudwatch_metric_alarm" "primary_db_connections" {

  alarm_name = "primary-db-no-connections"

  namespace   = "AWS/RDS"
  metric_name = "DatabaseConnections"

  statistic = "Average"

  period = 60

  evaluation_periods = 2

  threshold = 1

  comparison_operator = "LessThanThreshold"

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.primary.cluster_identifier
  }

  alarm_actions = [
    aws_sns_topic.dr_failover.arn
  ]
}

# Monitor to dc_dns health
resource "aws_cloudwatch_metric_alarm" "dc_dns_unhealthy" {

  alarm_name = "dc-dns-healthcheck-failed"

  namespace   = "AWS/Route53"
  metric_name = "HealthCheckStatus"

  statistic = "Minimum"

  period = 60

  evaluation_periods = 2

  threshold = 1

  comparison_operator = "LessThanThreshold"

  dimensions = {
    HealthCheckId = aws_route53_health_check.primary.id
  }

  treat_missing_data = "breaching"

  alarm_actions = [
    aws_sns_topic.dr_failover.arn
  ]
}
*/