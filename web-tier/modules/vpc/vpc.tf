resource "aws_vpc" "mainvpc" {
  cidr_block = var.CIDR_BLOCK

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "mainvpc"
    project = "web-tier"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainvpc.id

  tags = {
    Name    = "igw"
    project = "web-tier"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public-subnet" {
  count                   = length(var.PUBLIC_SUBNETS)
  vpc_id                  = aws_vpc.mainvpc.id
  cidr_block              = var.PUBLIC_SUBNETS[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-subnet-${count.index}"
    project = "web-tier"
  }
}


resource "aws_subnet" "private-subnet" {
  count             = length(var.PRIVATE_SUBNETS)
  vpc_id            = aws_vpc.mainvpc.id
  cidr_block        = var.PRIVATE_SUBNETS[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name    = "private-subnet-${count.index}"
    project = "web-tier"
  }
}


resource "aws_route_table" "public-rtt" {
  vpc_id = aws_vpc.mainvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "public-rtt"
    project = "web-tier"
  }
}

resource "aws_route_table_association" "associate-public-subnets" {
  count          = length(var.PUBLIC_SUBNETS)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-rtt.id
}

