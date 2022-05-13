
#Access Key
variable "AWS_ACCESS_KEY" {}

#Secret Key
variable "AWS_SECRET_KEY" {}

#Region
variable "AWS_REGION" {
  default = "eu-west-1"
}

#Ubuntu 20.04 focal
variable "AMIS" {
  type = map(any)
  default = {
    eu-west-1 = "ami-0076b212fad243d9e"
  }
}
