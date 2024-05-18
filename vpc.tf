
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block 
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_subnet" "subnet" {
  count = length (var.subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.subnet_cidr_blocks[count.index] 
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, 0)

  tags = {
    Name = "${var.environment}-subnet-${count.index}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "central_internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}


resource "aws_route_table" "central_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}


resource "aws_route" "central_route" {
  route_table_id         = aws_route_table.central_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.central_internet_gateway.id
}

resource "aws_route_table_association" "subnet_association" {
  count          = length(var.subnet_cidr_blocks)
  subnet_id      = aws_subnet.subnet[count.index].id
  route_table_id = aws_route_table.central_route_table.id
}


# resource "aws_security_group" "eks_security_group" {
#   name        = "ECSSecurityGroup"
#   description = "ECS security group"
#   vpc_id      = aws_vpc.vpc.id
#
#   ingress = [
#     {
#       description      = "In TCP 80"
#       from_port        = 80
#       to_port          = 80
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     },
#     {
#       description      = "In TCP 443"
#       from_port        = 443
#       to_port          = 443
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
#       security_groups  = []
#       self             = false
#     },
#     {
#       description      = "Allow all inbound traffic from within the security group"
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       self             = true
#       security_groups  = []
#       cidr_blocks      = []
#       ipv6_cidr_blocks = []
#       prefix_list_ids  = []
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

