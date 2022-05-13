#Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
  }
}

#Create subnet-a
resource "aws_subnet" "subnet-a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "subnet-a"
  }
}

#Create subnet-b
resource "aws_subnet" "subnet-b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "false"
  tags = {
    Name = "subnet-b"
  }
}

#Create the Internet Gateway
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "my-igw"
  }
}

#Allocate an Elastic IP
resource "aws_eip" "eip" {
  vpc = "true"
  tags = {
    Name = "My IP"
  }
}

#Create a NAT Gateway
resource "aws_nat_gateway" "my-nat-gateway" {
  subnet_id     = aws_subnet.subnet-a.id
  allocation_id = aws_eip.eip.id
  tags = {
    Name = "My NAT Gateway"
  }
}

#Create public route table for subnet-a
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

#Create private route table for subnet-b
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my-nat-gateway.id
  }
  tags = {
    Name = "private-route-table"
  }
}

#Associate public route table with subnet-a
resource "aws_route_table_association" "association-subnet-a" {
  subnet_id      = aws_subnet.subnet-a.id
  route_table_id = aws_route_table.public-route-table.id
}

#Associate public route table with subnet-b
resource "aws_route_table_association" "association-subnet-b" {
  subnet_id      = aws_subnet.subnet-b.id
  route_table_id = aws_route_table.private-route-table.id
}
