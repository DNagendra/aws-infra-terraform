#
# Variables Configuration
#

variable "vpc_cidr" {
  default = "190.160.0.0/16"
}

variable "subnet_cidr" {
  type = list
  default = ["190.160.1.0/24","190.160.2.0/24","190.160.3.0/24"]
}

variable "cluster-name" {
  default = "terraform-eks-cluster"
  type    = string
}

variable "aws_region" {
  default = "us-east-2"
  description = ""
}

# Declare the data source
data "aws_availability_zones" "azs" {
  state = "available"
}