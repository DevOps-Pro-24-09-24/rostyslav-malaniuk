# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Create public subnet
resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet_cidr}"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# Create private subnet
resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.private_subnet_cidr}"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "private-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "main-gateway"
  }
}

# Create WEB EC2 instance in public subnet
resource "aws_instance" "web" {
  ami           = "ami-0084a47cc718c111a"
  instance_type = "${var.instance_type}"
  subnet_id     = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_front.id}"]
  key_name      = "${var.key_name}"

  tags = {
    Name = "WEB Instance"
  }
}

# Create DB EC2 instance in private subnet
resource "aws_instance" "db" {
  ami           = "ami-0084a47cc718c111a"
  instance_type = "${var.instance_type}"
  subnet_id     = "${aws_subnet.private.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_back.id}"] 
  key_name      = "${var.key_name}"

  tags = {
    Name = "DB Instance"
  }
}
