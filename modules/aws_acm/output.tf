output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "cert_arn" {
  value = aws_acm_certificate.cert.arn
}
output "validation_record_fqdns" {
  value = aws_acm_certificate_validation.cert_validation.validation_record_fqdns
}