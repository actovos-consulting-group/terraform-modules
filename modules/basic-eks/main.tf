data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

locals {
  cluster_cert = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  host         = data.aws_eks_cluster.cluster.endpoint
  token        = data.aws_eks_cluster_auth.cluster.token
}

provider "kubernetes" {
  host                   = local.host
  cluster_ca_certificate = local.cluster_cert
  token                  = local.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "12.0.0"
  cluster_name = var.cluster_name
  subnets      = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id
  map_roles = [
    {
      "groups" : ["system:masters"],
      "rolearn" : aws_iam_role.eks_role.arn,
      "username" : var.cluster_name
    }
  ]
  worker_groups = [
    {
      name                          = "${var.cluster_name}_worker_1"
      instance_type                 = var.worker_instance_type
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "${var.cluster_name}_worker_2"
      instance_type                 = var.worker_instance_type
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
  tags = var.default_tags
}
