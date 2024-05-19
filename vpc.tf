
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block 
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))

  tags = {
    Name = var.name
    Environment = var.environment
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = false
  availability_zone = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))

  tags = {
    Name = var.name
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "central_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = var.name
    Environment = var.environment
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = var.name
    Environment = var.environment
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.central_internet_gateway.id
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}


# resource "aws_security_group" "rds_security_group" {
#   name        = "RDSSecurityGroup"
#   description = "RDS security group"
#   vpc_id      = aws_vpc.main_vpc.id
#
#   ingress = [
#     {
#       description      = "In TCP 3306"
#       from_port        = 3306 
#       to_port          = 3306 
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = [aws_security_group.eks_security_group.id]
#       self             = false
#     },
#   ]
#
#   egress = [
#     {
#       description      = "Allow all outbound traffic to the Internet"
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     },
#   ]
# }
