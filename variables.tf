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
  default     = "vpc-0XXXXXXX91a9"
}

variable "subnets-list" {
  type        = list(string)
  description = "subnet ids to be associated  with the load balancer"
  default     = ["subnet-0ad494XXXXXXXX7", "subnet-0056XXXXXXXX4"]
}

variable "TF_VERSION" {
  type        = string
  description = "terraform version."
  default     = "3.27"
}

variable "aws_account_id" {
  type        = string
  description = "aws account id."
  default     = "314XXXXXXX"
}

variable "REGION" {
  type        = string
  description = "aws Region"
  default     = "eu-central-1"
}

variable "lbtype" {
  description = "load balancer type, can be application , network or gateway "
  default     = "application"
}



