variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID for the domain"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the site"
  type        = string
  default     = "ikigai.metaspot.org"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.nano"
}

variable "public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_ecdsa.pub"
}
