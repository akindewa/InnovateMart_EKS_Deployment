# VPC, subnets, internet gateway, route tables

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "innovatemart-prod-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway     = false   # don't create NAT Gateway
  single_nat_gateway     = false
  enable_dns_hostnames   = true
  enable_dns_support     = true

  map_public_ip_on_launch = true


  tags = {
    Environment = "prod"
    Project     = "innovatemart"
  }
}



