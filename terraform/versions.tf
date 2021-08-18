terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 2.69"
    }
    local = {
      source = "hashicorp/local"
      version = "1.4.0"
    }
    null = {
      source = "hashicorp/null"
    }
    tls = {
      source = "hashicorp/tls"
      version = "2.1.1"
    }
  }
  required_version = ">= 0.13"
}
