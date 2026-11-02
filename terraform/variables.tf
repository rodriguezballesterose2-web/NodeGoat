variable "name" {
  type    = string
  default = "nodegoat"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "localstack_endpoint" {
  type    = string
  default = "http://localhost:4566"
}

variable "account_id" {
  description = "Cuenta AWS (000000000000 es la de LocalStack)"
  type        = string
  default     = "000000000000"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "app_port" {
  type    = number
  default = 4000
}

variable "ami_id" {
  description = "AMI de la instancia (LocalStack acepta cualquiera; en AWS real usar una valida)"
  type        = string
  default     = "ami-12345678"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
