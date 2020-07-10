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

# Security group for the ELK Server
resource "aws_security_group" "allow-elk_vr-server" {
    name = "ELK_server"
    description = "Allow ELK/SSH ports inbound"

    ingress {
        description  = "Allow SSH"
        from_port   = local.ssh_port
        to_port     = local.ssh_port
        protocol    = local.tcp_protocol
        cidr_blocks = local.all_ips
    }
    
    ingress {
        description  = "Allow Kibana Web"
        from_port   = local.kibana_web_port
        to_port     = local.kibana_web_port
        protocol    = local.tcp_protocol
        cidr_blocks = local.all_ips
    }

    ingress {
        description  = "Allow Velociraptor Web"
        from_port   = local.velociraptor_web_port
        to_port     = local.velociraptor_web_port
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
        Name = "ELK_VR_server"
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

# Key pair for instance
resource "aws_key_pair" "aws-elk-key" {
    key_name   = "ELK-Key"
    public_key = tls_private_key.elk-server-key.public_key_openssh
}

# Elastic IP for server for stability
resource "aws_eip" "elk_ip" {
    instance = aws_instance.elk_vr-server.id
    vpc      = true
}

# Create instance from Packer AMI, provide tag Name: ELK-Server and attached to new security group
resource "aws_instance" "elk_vr-server" {
    ami = data.aws_ami.ubuntu.id
    key_name = aws_key_pair.aws-elk-key.key_name
    instance_type = var.server-size # Default t2.large

    vpc_security_group_ids = [aws_security_group.allow-elk_vr-server.id]

    tags = {
        Name = "ELK-VR-Server"
        Terraform = true
    }

# Add custom bootstrap script to install and configure applications
    user_data = file("./user-data.sh")

}

###################
# TLS Provider
###################

provider "tls" {
    version = "2.1.1"
}

resource "tls_private_key" "elk-server-key" {
    algorithm   = "RSA"
    rsa_bits = 4096
}
