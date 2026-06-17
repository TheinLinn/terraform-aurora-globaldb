resource "aws_sns_topic" "dr_failover" {
  name = "dr-failover-topic"
}