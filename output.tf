output "primary_cluster_endpoint" {
  value = aws_rds_cluster.primary.endpoint
}

output "dr_cluster_endpoint" {
  value = aws_rds_cluster.dr.endpoint
}

output "global_cluster_id" {
  value = aws_rds_global_cluster.globaldb.id
}