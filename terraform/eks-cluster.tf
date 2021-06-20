provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

module "eks" {
  source                               = "terraform-aws-modules/eks/aws"
  cluster_name                         = local.cluster_name
  cluster_version                      = "1.18"
  subnets                              = module.vpc.private_subnets
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = [""]

  manage_aws_auth = true

  cluster_log_retention_in_days = 3

  cluster_enabled_log_types = ["api", "controllerManager", "scheduler"]

  tags = {
    Environment = "nonprod"
    CreatedBy = "terraform"
  }

  vpc_id = module.vpc.vpc_id

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    nodeGroup = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t3a.medium"
      k8s_labels = {
        Environment = "dev"
        CreatedBy = "terraform"
      }
    }
  }

  map_users = [
    {
      userarn  = "arn:aws:iam::012405793350:user/automation"
      username = "automation"
      groups   = ["system:masters"]
    }
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
