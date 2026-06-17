/*
# Global Cluster
resource "aws_rds_global_cluster" "globaldb" {
  global_cluster_identifier = "${var.project_name}-globaldb"

  engine         = "aurora-postgresql"
  engine_version = var.engine_version

  storage_encrypted = true
}

# Primary cluster
resource "aws_rds_cluster" "primary" {
  cluster_identifier = "${var.project_name}-primary"

  engine         = "aurora-postgresql"
  engine_version = var.engine_version

  global_cluster_identifier = aws_rds_global_cluster.globaldb.id

  database_name = var.db_name
  master_username = var.db_username
  master_password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.primary.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]

  backup_retention_period = 7
  preferred_backup_window = "02:00-03:00"

  storage_encrypted = true
  kms_key_id        = aws_kms_key.primary.arn

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 2
  }

  skip_final_snapshot = true
}

# Primary Writer Instance
resource "aws_rds_cluster_instance" "primary_writer" {
  identifier         = "${var.project_name}-writer"
  cluster_identifier = aws_rds_cluster.primary.id

  instance_class = var.db_instance_class

  engine         = aws_rds_cluster.primary.engine
  engine_version = aws_rds_cluster.primary.engine_version

  publicly_accessible = false
}

# Primary Reader Instance
 resource "aws_rds_cluster_instance" "primary_reader" {
  identifier         = "${var.project_name}-reader"
  cluster_identifier = aws_rds_cluster.primary.id

  instance_class = var.db_instance_class

  engine         = aws_rds_cluster.primary.engine
  engine_version = aws_rds_cluster.primary.engine_version

  publicly_accessible = false
}

# DR Cluster
resource "aws_rds_cluster" "dr" {
  provider = aws.dr

  cluster_identifier = "${var.project_name}-dr"

  engine         = "aurora-postgresql"
  engine_version = var.engine_version

  global_cluster_identifier = aws_rds_global_cluster.globaldb.id

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 2
  }

  db_subnet_group_name   = aws_db_subnet_group.dr.name
  vpc_security_group_ids = [aws_security_group.dr_aurora_sg.id]

  storage_encrypted = true
  kms_key_id        = aws_kms_key.dr.arn

  skip_final_snapshot = true

  depends_on = [
    aws_rds_cluster_instance.primary_writer,
    aws_rds_cluster_instance.primary_reader
  ]
}

# DR Reader Instance
resource "aws_rds_cluster_instance" "dr_reader" {
  provider = aws.dr

  identifier         = "${var.project_name}-dr-reader"
  cluster_identifier = aws_rds_cluster.dr.id

  instance_class = var.db_instance_class

  engine         = aws_rds_cluster.dr.engine
  engine_version = aws_rds_cluster.dr.engine_version

  publicly_accessible = false
}

# Create KMS key in primary region for cross-region replication
resource "aws_kms_key" "primary" {
  description = "Primary Aurora KMS key"
}

# Create KMS key in dr region for cross-region replication
resource "aws_kms_key" "dr" {
  provider = aws.dr

  description = "DR Aurora KMS key"
}
*/