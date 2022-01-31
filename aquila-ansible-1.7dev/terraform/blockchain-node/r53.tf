resource "aws_route53_record" "www" {
  zone_id         = var.r53_hosted_zone_id
  name            = var.r53_record
  type            = "CNAME"
  ttl             = 300
  records      =  [aws_lb.application-load-balancer.dns_name]
 
  allow_overwrite = true
}