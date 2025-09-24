# Input variables (region, cluster name, VPC CIDRs, etc.)

variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  default     = "1.32"
}
