# Create read-only IAM user for development team
resource "aws_iam_user" "developer" {
  name = "eks-developer-readonly"

  tags = {
    Environment = "dev"
    Project     = "innovatemart"
    Purpose     = "EKS read-only access for development team"
  }
}

# Attach EKS View policy
resource "aws_iam_user_policy_attachment" "developer_eks_view" { # ← CHANGED NAME
  user       = aws_iam_user.developer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Attach general ReadOnly policy  
resource "aws_iam_user_policy_attachment" "developer_readonly" { # ← CHANGED NAME
  user       = aws_iam_user.developer.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Output user ARN for EKS access configuration
output "developer_user_arn" {
  description = "ARN of the developer read-only user for EKS access"
  value       = aws_iam_user.developer.arn
}

# Output credential generation command
output "credential_generation_command" {
  description = "Command to generate access credentials for the developer user"
  value       = "aws iam create-access-key --user-name ${aws_iam_user.developer.name}"
}






