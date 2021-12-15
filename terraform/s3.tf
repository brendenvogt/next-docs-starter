# ===== S3 =====

variable "site_output_dir" {
  type        = string
  description = "output directory relative to src where your static site is located"
  default     = "out"
}

# Bucket to store logs
resource "aws_s3_bucket" "website_logs" {
  bucket = "${var.website_domain_main}-logs"
  acl    = "log-delivery-write"

  # Comment the following line if you are uncomfortable with Terraform destroying the bucket even if this one is not empty
  force_destroy = true

  tags = merge(var.tags, {
    site        = var.website_domain_main
    environment = "production"
    ManagedBy   = "terraform"
    Changed     = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  })

  lifecycle {
    ignore_changes = [tags["Changed"]]
  }
}

# Bucket to store the static website
resource "aws_s3_bucket" "website_root" {
  bucket = "${var.website_domain_main}-root"
  acl    = "public-read"

  # Comment the following line if you are uncomfortable with Terraform destroying the bucket even if not empty
  force_destroy = true

  # This is the name of the S3 bucket where access logs will be
  # written.  We'll create this bucket in a moment
  logging {
    target_bucket = aws_s3_bucket.website_logs.bucket
    target_prefix = "${var.website_domain_main}/"
  }

  website {
    # This tells AWS to use the file index.html if someone requests 
    # a directory like http://www.«your site».com/about/
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = merge(var.tags, {
    site        = var.website_domain_main
    environment = "production"
    ManagedBy   = "terraform"
    Changed     = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  })

  lifecycle {
    ignore_changes = [tags["Changed"]]
  }
}

# Creates bucket for the website handling the redirection (if required), e.g. from https://www.example.com to https://example.com
resource "aws_s3_bucket" "website_redirect" {
  bucket        = "${var.website_domain_main}-redirect"
  acl           = "public-read"
  force_destroy = true

  logging {
    target_bucket = aws_s3_bucket.website_logs.bucket
    target_prefix = "${var.website_domain_main}-redirect/"
  }

  # This tells AWS you want this S3 bucket to serve up a website
  website {
    redirect_all_requests_to = "https://${var.website_domain_main}"
  }

  tags = merge(var.tags, {
    site        = var.website_domain_main
    environment = "production"
    ManagedBy   = "terraform"
    Changed     = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  })

  lifecycle {
    ignore_changes = [tags["Changed"]]
  }
}


# Creates policy to allow public access to the S3 bucket
resource "aws_s3_bucket_policy" "update_website_root_bucket_policy" {
  bucket = aws_s3_bucket.website_root.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PolicyForWebsiteEndpointsPublicContent",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "${aws_s3_bucket.website_root.arn}/*",
        "${aws_s3_bucket.website_root.arn}"
      ]
    }
  ]
}
POLICY
}

locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
}

resource "aws_s3_bucket_object" "object" {
  for_each = fileset("${path.module}/../${var.site_output_dir}", "**/*")
  bucket   = aws_s3_bucket.website_root.id
  key      = each.value

  # sources files from the var.site_output_dir from the parent directory 
  source = "${path.module}/../${var.site_output_dir}/${each.value}"
  etag   = filemd5("${path.module}/../${var.site_output_dir}/${each.value}")

  # assigns the file content_type with the mime type for the file's extension
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}
