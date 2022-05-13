#Print the public IP of the server-1 in the subnet-a
output "ip" {
  value = aws_instance.instance-1-subnet-a.public_ip
}
