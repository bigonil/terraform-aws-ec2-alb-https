output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}
output "alb" {
  value = aws_lb.web_alb
}