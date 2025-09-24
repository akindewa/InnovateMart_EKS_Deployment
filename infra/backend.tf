# Remote state backend (S3 + DynamoDB)
terraform {
  backend "s3" {
    bucket  = "innovatemart"          # bucket must exist in S3
    key     = "eks/terraform.tfstate" # path inside bucket
    region  = "eu-west-1"
    encrypt = true
  }
}
