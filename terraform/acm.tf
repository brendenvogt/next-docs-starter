
# ===== ACM (AWS Certificate Manager) =====

# # Creates the wildcard certificate *.<yourdomain.com>
resource "aws_acm_certificate" "wildcard_website" {
  domain_name               = var.website_domain_main
  subject_alternative_names = ["*.${var.website_domain_main}"]
  validation_method         = "DNS"

  tags = merge(var.tags, {
    ManagedBy = "terraform"
    Changed   = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  })

  lifecycle {
    ignore_changes = [tags["Changed"]]
  }
}

# # Triggers the ACM wildcard certificate validation event
resource "aws_acm_certificate_validation" "wildcard_cert" {
  # provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.wildcard_website.arn
  validation_record_fqdns = [for k, v in aws_route53_record.wildcard_validation : v.fqdn]
}


# # Get the ARN of the issued certificate
data "aws_acm_certificate" "wildcard_website" {

  depends_on = [
    aws_acm_certificate.wildcard_website,
    aws_route53_record.wildcard_validation,
    aws_acm_certificate_validation.wildcard_cert,
  ]

  domain      = var.website_domain_main
  statuses    = ["ISSUED"]
  most_recent = true
}
