variable "domain_name" {
  type        = string
  description = "The domain name for the website."
  default = "buildwithaws.com"
}
variable "bucket_name" {
  type        = string
  description = "The name of the bucket to host your frontend code"
  default="www.buildwithaws.com"
}

variable "api_gateway_invoke_URL" {
  type        = string
  description = "The invoke URL of your API gateway"
  default="https://hc9twvoiyd.execute-api.us-east-1.amazonaws.com/test"
  
}