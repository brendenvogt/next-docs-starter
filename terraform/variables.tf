# Input variable definitions
variable "aws_region" {
  type        = string
  description = "The AWS region to put the bucket into"
  default     = "us-east-1"
}

variable "website_domain_main" {
  type        = string
  description = "The main website domain name that will be receiving the traffic"
  # Put defaults here if you don't want to specify them all the time
}

variable "website_domain_redirect" {
  type        = string
  description = "The redirect domain that will be redirecting traffic to the main domain"
  # Put defaults here if you don't want to specify them all the time
}

variable "tags" {
  description = "Tags added to resources"
  default     = {}
  type        = map(string)
}
