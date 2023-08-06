resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count = 2
  cidr_block = "10.0.${count.index}.0/24"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "web" {
  // Define security group rules for web instances
}

resource "aws_security_group" "db" {
  // Define security group rules for database instances
}

resource "aws_instance" "web" {
  count = 2
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[count.index].id
  security_groups = [aws_security_group.web.name]
}

resource "aws_instance" "db" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id
  security_groups = [aws_security_group.db.name]
}
