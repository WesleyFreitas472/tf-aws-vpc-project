
#Create a security group associate with the VPC
resource "aws_security_group" "my-security-group" {
  vpc_id = aws_vpc.main.id
  name   = "my-security-group"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create key pair to access the instance
resource "aws_key_pair" "mykeypair" {
  key_name   = "tf_mykey"
  public_key = file("~/.ssh/mykey.pub")
}

#Create my server exposed to the internet
resource "aws_instance" "instance-1-subnet-a" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  security_groups = ["${aws_security_group.my-security-group.id}"]
  subnet_id       = aws_subnet.subnet-a.id
  key_name        = aws_key_pair.mykeypair.key_name
}

#Create my server exposed to the internet
resource "aws_instance" "instance-1-subnet-b" {
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"

  security_groups = ["${aws_security_group.my-security-group.id}"]
  subnet_id       = aws_subnet.subnet-b.id
  key_name        = aws_key_pair.mykeypair.key_name
}
