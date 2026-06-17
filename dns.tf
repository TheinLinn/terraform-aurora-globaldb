# Create Route53 hosted zone
resource "aws_route53_zone" "hosted" { # look existing hosted zone(need to update)
  name = "citytrust.com"
}

/*# Call the existing hosted zone
data "aws_route53_zone" "hosted" {
  name         = "citytrust.com"
  private_zone = false
}*/

# Primary health check monitors your main endpoint
resource "aws_route53_health_check" "primary" {
  fqdn              = aws_lb.dc_alb.dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
  tags = {
    Name = "dc-alb-healthcheck"
  }
}

/*# Secondary health check ensures backup readiness.
resource "aws_route53_health_check" "secondary" {
  fqdn              = aws_lb.dr_alb.dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold  = 3
  request_interval   = 30
}*/

# DNS record for dc
resource "aws_route53_record" "dc_dns" {

  zone_id = aws_route53_zone.hosted.zone_id
  name    = "citytrust.com"
  type    = "A"

  set_identifier = "singapore"

  weighted_routing_policy {
    weight = 100
  }

  health_check_id = aws_route53_health_check.primary.id

  alias {
    name                   = aws_lb.dc_alb.dns_name
    zone_id                = aws_lb.dc_alb.zone_id
    evaluate_target_health = true
  }
}

# DNS record for dr
resource "aws_route53_record" "dr_dns" {

  zone_id = aws_route53_zone.hosted.zone_id
  name    = "citytrust.com"
  type    = "A"

  set_identifier = "tokyo"

  weighted_routing_policy {
    weight = 0
  }

  #  health_check_id = aws_route53_health_check.secondary.id 

  alias {
    name                   = aws_lb.dr_alb.dns_name
    zone_id                = aws_lb.dr_alb.zone_id
    evaluate_target_health = true
  }
}
