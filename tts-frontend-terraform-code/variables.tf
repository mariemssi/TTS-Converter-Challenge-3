# I chose to pass this variable as secrets in github actions workflows
variable "domain_name" {
  type        = string
  description = "The domain name for the website."
  #default     = "your_default_domain_name"
}
variable "bucket_name" {
  type        = string
  description = "The name of the bucket to host your frontend code"
  #default     = "your_default_bucket_name"
}

#The backend should be created before 
variable "api_gateway_invoke_URL" {
  type        = string
  description = "The invoke URL of your API gateway"
  #default     = "your_default_api_gateway_invoke_URL"

}