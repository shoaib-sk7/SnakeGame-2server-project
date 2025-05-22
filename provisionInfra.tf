# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Public Subnet - us-east-1a
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-public-1a"
  }
}

# Public Subnet - us-east-1b
resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-public-1b"
  }
}

# Private Subnet - us-east-1a
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-private-1a"
  }
}

# Private Subnet - us-east-1b
resource "aws_subnet" "private_1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-private-1b"
  }
}

# EIP for NAT
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# NAT Gateway in public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1a.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "nat-gateway"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "route-public"
  }
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "route-private"
  }
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_1b.id
  route_table_id = aws_route_table.private.id
}

# Security Group - Allow All (for testing only!)
resource "aws_security_group" "all_open" {
  name        = "all-open"
  vpc_id      = aws_vpc.main.id
  description = "Allow all inbound and outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-all-open"
  }
}

# EC2 Frontend - Public Subnet
resource "aws_instance" "frontend" {
  ami                         = "ami-0fc5d935ebf8bc3bc"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1a.id
  associate_public_ip_address = true
  key_name                    = "SecureFirst"
  vpc_security_group_ids      = [aws_security_group.all_open.id]

  tags = {
    Name = "frontend-instance"
  }
}

# EC2 Backend - Private Subnet
resource "aws_instance" "backend" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_1b.id
  key_name               = "SecureFirst"
  vpc_security_group_ids = [aws_security_group.all_open.id]

  tags = {
    Name = "backend-instance"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main-db-subnet-group"
  subnet_ids = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]

  tags = {
    Name = "db-subnet-group"
  }
}

# RDS MySQL 8.0.37 - Free Tier
resource "aws_db_instance" "mysql" {
  identifier              = "my-mysql-db"
  allocated_storage       = 20
  max_allocated_storage   = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0.37"
  instance_class          = "db.t3.micro" # Free tier
  username                = "admin"
  password                = "Admin-123" # Replace in prod
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.all_open.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  deletion_protection     = false

  tags = {
    Name = "mysql-db-instance"
  }
}
