
output "primary_cluster_endpoint" {
  value = aws_rds_cluster.primary.endpoint
}

output "dr_cluster_endpoint" {
  value = aws_rds_cluster.dr.endpoint
}

output "global_cluster_id" {
  value = aws_rds_global_cluster.globaldb.id
}

output "hosted_zone_id" {
  value = aws_route53_zone.hosted.zone_id
}

output "alb_zone_id" {
  value = aws_lb.dc_alb.zone_id
}

output "alb_dns_name" {
  value = aws_lb.dc_alb.dns_name
}
