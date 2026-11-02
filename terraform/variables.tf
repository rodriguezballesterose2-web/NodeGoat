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

variable "enable_lifecycle_rules" {
  description = "Reglas de ciclo de vida de S3. Se apagan en LocalStack, que no las confirma."
  type        = bool
  default     = true
}

variable "enable_instance" {
  description = "Instancia EC2. Se apaga en LocalStack, que no emula bien su lectura."
  type        = bool
  default     = true
}
