variable "aws-cli-profile" {
    type        = string
    default     = ""
    description = "AWS CLI profile used to authenticate Terraform"
}

variable "aws-region" {
    type        = string
    default     = "us-east-1"
    description = "Region to launch DH assets in"
}

variable "ebs-size" {
    type        = number
    default     = 150
    description = "The EBS GB size of the DH server"
}

variable "server-size" {
    type        = string
    default     = "t2.large"
    description = "The AWS instance type of the DH server"
}

locals {
    ssh_port                = 22
    velociraptor_agent_port = 8000
    any_port                = 0
    any_protocol            = -1
    tcp_protocol            = "tcp"
}

variable "ssh-ingress-ips" {
    type = list(string)
    default = ["0.0.0.0/0"]
    description = "List of IPs allowed to ssh to the dino instance"
}

variable "vr-agent-ingress-ips" {
    type = list(string)
    default = ["0.0.0.0/0"]
    description = "List of IPs allowed to ssh to the dino instance"
}

variable "dh-server-egress-ips" {
    type = list(string)
    default = ["0.0.0.0/0"]
    description = "List of IPs the vr instance is allowed to egress to"
}

variable "server-name" {
    type = string
    default = "dh_server"
    description = "Name for the velociraptor dino hunter server"
}