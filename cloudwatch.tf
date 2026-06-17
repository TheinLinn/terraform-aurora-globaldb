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

# Monitor ALB/ECS health check
resource "aws_cloudwatch_metric_alarm" "primary_unhealthy" {

  alarm_name          = "primary-alb-unhealthy"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2

  metric_name = "HealthyHostCount"
  namespace   = "AWS/ApplicationELB"

  period    = 60
  statistic = "Average"

  threshold = 1

  dimensions = {
    LoadBalancer = aws_lb.dc_alb.arn_suffix
    TargetGroup  = aws_lb_target_group.dc_tg.arn_suffix
  }

  alarm_actions = [ # updated by June-15
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