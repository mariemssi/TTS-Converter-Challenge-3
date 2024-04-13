# The purpose of this file is to better organize the Terraform code.
# It will contain information about providers, Terraform version,

# The AWS region selected for deployment.
provider "aws" {
  region = "us-east-1"
}

terraform {
  # Ensures uniform usage of a specific Terraform version.
  required_version = ">= 0.14.9"

  # In challenge 1, a local Terraform state was used.
  # For this challenge, a remote Terraform backend is defined to run Terraform code.
  # GitHub Actions employs a runner for each job, and a different runner is used each time, 
  # causing the local state to be lost after each workflow execution.
  # Hence, to consistently maintain the state of AWS-deployed resources, the state should be stored remotely. 
  # In our case, it's an S3 bucket where Terraform stores its state to track managed resources.
  # I manually created the S3 bucket, as it must exist during Terraform initialization.
  # Management of this bucket can be done using a separate Terraform configuration not part of the project 
  backend "s3" {
    bucket = "terrform-state-bucket-23032024" # Change this bucket name to yours.
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }
}
