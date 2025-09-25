

# Reference existing IAM user instead of creating
data "aws_iam_user" "developer" {
  user_name = "eks-developer-readonly"
}

# Attach EKS View policy
resource "aws_iam_user_policy_attachment" "developer_eks_view" {
  user       = data.aws_iam_user.developer.user_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Attach general ReadOnly policy  
resource "aws_iam_user_policy_attachment" "developer_readonly" {
  user       = data.aws_iam_user.developer.user_name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Output user ARN for EKS access configuration
output "developer_user_arn" {
  description = "ARN of the developer read-only user for EKS access"
  value       = data.aws_iam_user.developer.arn
}

# Output credential generation command (manual step for existing user)
output "credential_generation_command" {
  description = "Command to generate access credentials for the developer user"
  value       = "aws iam create-access-key --user-name ${data.aws_iam_user.developer.user_name}"
}




