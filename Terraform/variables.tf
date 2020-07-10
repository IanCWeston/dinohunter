variable "aws-cli-profile" {
    type        = string
    default     = ""
    description = "AWS CLI profile used to authenticate Terraform"
}

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

locals {
    ssh_port                = 22
    velociraptor_agent_port = 8000
    any_port                = 0
    any_protocol            = -1
    tcp_protocol            = "tcp"
    all_ips                 = ["0.0.0.0/0"]
}
