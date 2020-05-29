resource "aws_route53_record" "dns" {
  zone_id = var.route53_zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_alb.lb.dns_name
    zone_id                = aws_alb.lb.dns_name
    evaluate_target_health = true
  }
}
