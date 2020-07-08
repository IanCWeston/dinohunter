variable "aws-region" {
    type        = string
    default     = "us-east-1"
    description = "Region to launch ELK stack in"
}

variable "server-size" {
    type        = string
    default     = "t2.large"
    description = "The AWS instance type of the ELK server"
}

