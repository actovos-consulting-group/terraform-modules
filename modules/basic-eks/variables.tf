variable "cluster_name" {
  type = string
}

variable "worker_instance_type" {
  type    = string
  default = "t2.medium"
}

variable "vpc_id" {
  type    = string
}

variable "eks_subnet_ids" {
  type    = list
}

variable "default_tags" {
  type = map
  default = {
    Module : "acg/basic-eks"
    Terraform : "1",
  }
}
