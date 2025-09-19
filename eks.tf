 # EKS cluster + node groups

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "innovatemart-prod-eks"
  cluster_version = "1.32"




  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets   # use public to avoid NAT Gateway bills

  enable_irsa = true   # IAM roles for service accounts

  eks_managed_node_groups = {
    default = {
      instance_types = ["t2.micro"]   # free tier eligible
      min_size       = 1
      max_size       = 1
      desired_size   = 1
    }
  }


 # **DISABLE KMS encryption**
  cluster_encryption_config = []

  tags = {
    Environment = "prod"
    Project     = "innovatemart"
  }
}


