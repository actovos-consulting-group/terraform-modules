variable "name" {
  type = string
}

variable "cert_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "lb_subnet_ids" {
  type = list
}

variable "route53_zone_id" {
  type = string
}

variable "domain" {
  type = string
}

variable "default_tags" {
  type = map
  default = {
    Terraform : "1",
  }
}
