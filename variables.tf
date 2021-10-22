variable "suffix" {
  type        = string
  description = "suffix to identify all resoures created by me."
  default     = "asmt-1-cmba"
}

variable "image_tag" {
  type        = string
  description = "Tag for docker file."
  default     = "latest"
}

variable "vpc-id" {
  description = "exisiting vpc-id which will be associated with the loadbalancer"
  default     = "vpc-087b4e0167a2591a9"
}

variable "subnets-list" {
  type        = list(string)
  description = "subnet ids to be associated  with the load balancer"
  default     = ["subnet-0ad4947b529ea6577", "subnet-0056cb89cd49ab2e4"]
}

variable "TF_VERSION" {
  type        = string
  description = "terraform version."
  default     = "3.27"
}

variable "aws_account_id" {
  type        = string
  description = "aws account id."
  default     = "314053136453"
}

variable "REGION" {
  type        = string
  description = "aws Region"
  default     = "eu-central-1"
}



