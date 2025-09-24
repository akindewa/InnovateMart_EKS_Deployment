# Output values (cluster endpoint, node group role ARN, etc.)
#  output "cluster_name" {
#   value = aws_eks_cluster.eks.name
# }

# output "cluster_endpoint" {
#   value = aws_eks_cluster.eks.endpoint
# }

# output "cluster_ca_certificate" {
#   value = aws_eks_cluster.eks.certificate_authority[0].data
# }


# output "vpc_id" {
#   description = "The ID of the VPC"
#   value       = module.vpc.vpc_id
# }

# output "private_subnets" {
#   description = "Private subnets"
#   value       = module.vpc.private_subnets
# }

# output "public_subnets" {
#   description = "Public subnets"
#   value       = module.vpc.public_subnets
# }

# output "cluster_name" {
#   description = "EKS cluster name"
#   value       = module.eks.cluster_name
# }

# output "cluster_endpoint" {
#   description = "EKS cluster endpoint"
#   value       = module.eks.cluster_endpoint
# }

# output "cluster_certificate_authority" {
#   description = "EKS cluster CA data"
#   value       = module.eks.cluster_certificate_authority_data
# }





# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnets"
  value       = module.vpc.public_subnets
}

# EKS outputs
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority" {
  description = "EKS cluster CA data"
  value       = module.eks.cluster_certificate_authority_data
}


//IAM user outputs for dev-readonly-user

# output "dev_readonly_access_key_id" {
#   value     = aws_iam_access_key.dev_readonly_key.id
#   sensitive = true
# }

# output "dev_readonly_secret_access_key" {
#   value     = aws_iam_access_key.dev_readonly_key.secret
#   sensitive = true
# }

