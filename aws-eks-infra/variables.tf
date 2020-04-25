#
# Variables Configuration
#

variable "cluster-name" {
  default = "terraform-eks-cluster"
  type    = string
}

variable "aws_region" {
  default = "us-east-2"
  description = ""
}
