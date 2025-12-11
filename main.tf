resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr

  tags = {
    Name = "spy-vpc"
  }
}
  
resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = each.key
  }
}
resource "aws_instance" "spy_ec2s" {
  for_each = var.spy_ec2s

  ami           = each.value.ami
  instance_type = each.value.instance_type
  key_name      = each.value.keypair

  subnet_id = aws_subnet.subnets["subnet-${each.value.no}"].id

  associate_public_ip_address = each.value.public

  tags = {
    Name = each.key
  }
}
