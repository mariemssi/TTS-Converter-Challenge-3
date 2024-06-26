# The AWS region selected for deployment.
provider "aws" {
  region = "us-east-1"
}

# CloudFront requires SSL certificates to be provisioned in the North Virginia (us-east-1) region
# you should set it if you choose another region for your app


terraform {
  required_version = ">= 0.14.9"

  # To consistently maintain the state of tts converter frontend AWS-deployed resources, the state should be stored remotely. 
  # In our case, it's an S3 bucket where Terraform stores its state to track managed resources.
  # I manually created the S3 bucket, as it must exist during Terraform initialization.
  # Management of this bucket can be done using a separate Terraform configuration not part of the project
  # I chose the same S3 bucket as for the backend terraform state with a different prefix 
  backend "s3" {
    bucket = "terrform-state-bucket-23032024" # Change this bucket name to yours 
    key    = "frontend/terraform.tfstate"
    region = "us-east-1"
  }
}
