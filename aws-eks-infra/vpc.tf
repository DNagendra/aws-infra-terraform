#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "infi-vpc" {
  cidr_block = var.vpc_cidr

  tags = map(
    "Name", "terraform-eks-infi-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "subnets" {
  count = length(data.aws_availability_zones.azs.names)
  availability_zone = element(data.aws_availability_zones.azs.names,count.index)
  cidr_block        = element(var.subnet_cidr,count.index)
  vpc_id            = aws_vpc.infi-vpc.id
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-${count.index+1}"
    Name = "terraform-eks-cluster"
      "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_internet_gateway" "eks-ig" {
  vpc_id = aws_vpc.infi-vpc.id

  tags = {
    Name = "terraform-eks-cluster"
  }
}

resource "aws_route_table" "eks-rt" {
  vpc_id = aws_vpc.infi-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-ig.id
  }
}

resource "aws_route_table_association" "eks-rta" {
  count = length(aws_subnet.subnets)

  subnet_id      = aws_subnet.subnets.*.id[count.index]
  route_table_id = aws_route_table.eks-rt.id
}