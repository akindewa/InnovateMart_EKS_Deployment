# EKS cluster + node groups

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "innovatemart-prod-eks"
  cluster_version = "1.32"




  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]


  enable_irsa = true

  # Use access_entries instead of aws_auth_users
  access_entries = {
    innovatemart-setup = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::919113286163:user/innovatemart-setup"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
    developer = { # Changed from "instructor" to "developer"
      kubernetes_groups = []
      principal_arn     = aws_iam_user.developer.arn # Changed to match IAM resource
      policy_associations = {
        readonly = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }





  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 1
    }
  }


  # **DISABLE KMS encryption**
  cluster_encryption_config = []

  tags = {
    Environment = "dev"
    Project     = "innovatemart"
  }
}



