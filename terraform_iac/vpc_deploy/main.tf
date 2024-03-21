
resource "aws_vpc" "app_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "${var.app_name}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.app_name}-internet-gw"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone       = element(var.AZs, 0)

  tags = {
    Name = "${var.app_name}-private"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(var.AZs, 0)

  tags = {
    Name = "${var.app_name}-public-a"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id     = aws_vpc.app_vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = element(var.AZs, 1)

  tags = {
    Name = "${var.app_name}-public-b"
  }
}

resource "aws_eip" "natgw" {}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public-a.id

  tags = {
    Name = "${var.app_name}-NATGW"
  }
}

resource "aws_route_table" "nat-rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "${var.app_name}-natgw-route-table"
  }
}

resource "aws_route_table" "igw-rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.app_name}-igw-route-table"
  }
}

resource "aws_route_table_association" "public-a_asso" {
 subnet_id      = aws_subnet.public-a.id
 route_table_id = aws_route_table.igw-rt.id
}

resource "aws_route_table_association" "public-b_asso" {
 subnet_id      = aws_subnet.public-b.id
 route_table_id = aws_route_table.igw-rt.id
}

resource "aws_route_table_association" "private_subnet_asso" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.nat-rt.id
}

