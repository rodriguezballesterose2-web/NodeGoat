terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }
}

# Configuracion para LocalStack (emulador de AWS). Para usar AWS real:
# quitar el bloque endpoints, las claves de prueba y los parametros skip_*.
provider "aws" {
  region                      = var.region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    ec2  = var.localstack_endpoint
    iam  = var.localstack_endpoint
    kms  = var.localstack_endpoint
    logs = var.localstack_endpoint
    s3   = var.localstack_endpoint
    sts  = var.localstack_endpoint
  }
}
