terraform {
    required_version = ">= 0.12"
}

######################
# AWS Provider
######################

provider "aws" {
    region      = var.aws-region # Default us-east-1
    profile     = var.aws-cli-profile # Defaults to empty string
    version = "~> 2.69"
}

# Security group for the DH Server
resource "aws_security_group" "allow-dh-server" {
    name = "DH_server"
    description = "Allow Velociraptor/SSH ports inbound"

    ingress {
        description  = "Allow SSH"
        from_port   = local.ssh_port
        to_port     = local.ssh_port
        protocol    = local.tcp_protocol
        cidr_blocks = local.all_ips
    }
    
    ingress {
        description  = "Allow Velociraptor Agent"
        from_port   = local.velociraptor_agent_port
        to_port     = local.velociraptor_agent_port
        protocol    = local.tcp_protocol
        cidr_blocks = local.all_ips
    }
    
    egress {
        from_port   = local.any_port
        to_port     = local.any_port
        protocol    = local.any_protocol
        cidr_blocks = local.all_ips
    }

    tags = {
        Name = "dh_server"
        Terraform = true
    }

}

# Call for latest Ubuntu 18.04 AMI
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
    name   = "virtualization-type"
    values = ["hvm"]
    }

    owners = ["099720109477"]
}

# Key pair for instance using the generated SSH key
resource "aws_key_pair" "aws-dh-key" {
    key_name   = "DH-Key"
    public_key = tls_private_key.dh-server-key.public_key_openssh
}

# Create Elastic IP for server
resource "aws_eip" "dh_ip" {
    instance = aws_instance.dh-server.id
    vpc      = true
}

# Create instance from Ubuntu AMI, add tags and link key/security group
resource "aws_instance" "dh-server" {
    ami = data.aws_ami.ubuntu.id
    key_name = aws_key_pair.aws-dh-key.key_name
    instance_type = var.server-size # Default t2.large

    vpc_security_group_ids = [aws_security_group.allow-dh-server.id]

    tags = {
        Name = "DH-Server"
        Terraform = true
    }

# Add custom bootstrap script to install and configure applications
    user_data = file("../config/user-data.sh")

}

###################
# TLS Provider
###################

provider "tls" {
    version = "2.1.1"
}

# Generate a new SSH private key
resource "tls_private_key" "dh-server-key" {
    algorithm   = "RSA"
    rsa_bits = 4096
}

###################
# Local Provider
###################

provider "local" {
    version = "1.4.0"
}

# Generate a .pem file with the SSH private key and 400 permissions
resource "local_file" "pem-key" {
    sensitive_content = tls_private_key.dh-server-key.private_key_pem
    filename = "./dh-server.pem"
    file_permission = "0400"
}