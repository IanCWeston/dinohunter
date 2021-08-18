terraform {
    required_version = ">= 0.12"
}

######################
# AWS Provider
######################

provider "aws" {
    region      = var.aws-region # Default us-east-1
    profile     = var.aws-cli-profile # Defaults to empty string
}

# Security group for the DH Server
resource "aws_security_group" "allow-dh-server" {
    name = "${var.server-name}-sec-group"
    description = "Allow Velociraptor/SSH ports inbound"

    ingress {
        description  = "Allow SSH"
        from_port   = local.ssh_port
        to_port     = local.ssh_port
        protocol    = local.tcp_protocol
        cidr_blocks = var.ssh-ingress-ips
    }

    ingress {
        description  = "Allow Velociraptor Agent"
        from_port   = local.velociraptor_agent_port
        to_port     = local.velociraptor_agent_port
        protocol    = local.tcp_protocol
        cidr_blocks = var.vr-agent-ingress-ips
    }

    egress {
        from_port   = local.any_port
        to_port     = local.any_port
        protocol    = local.any_protocol
        cidr_blocks = var.dh-server-egress-ips
    }

    tags = {
        Name = var.server-name
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
    key_name   = "${var.server-name}-key"
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

    root_block_device {
        volume_size = var.ebs-size # Default 150GB
    }

    tags = {
        Name = var.server-name
        Terraform_Provisioned = "true"
    }

# Add custom bootstrap script to install and configure applications
    user_data = file("${path.module}/config/user-data.sh")

}

###################
# TLS Provider
###################

provider "tls" {

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

}

# Generate a .pem file with the SSH private key and 400 permissions
resource "local_file" "pem-key" {
    sensitive_content = tls_private_key.dh-server-key.private_key_pem
    filename = "../${var.server-name}-connect/${var.server-name}.pem"
    file_permission = "0400"
}

resource "local_file" "connect-script" {
    filename = "../${var.server-name}-connect/connect.sh"
    content = <<EOT
#! /bin/bash 

#################################################
# SSH and Portforward for kibana and velociraptor
#################################################

echo "Connecting now..."
ssh -i ${var.server-name}.pem -L 5601:localhost:5601 -L 8889:localhost:8889 ubuntu@${aws_eip.dh_ip.public_dns}
EOT
}

resource "null_resource" dh-server-config {
    depends_on = [aws_instance.dh-server]    
    connection {
        type = "ssh"
        host = aws_eip.dh_ip.public_dns
        user = "ubuntu"
        port = 22
        agent = true
        private_key = tls_private_key.dh-server-key.private_key_pem
    }
    
    provisioner "file" {
        source = "${path.module}/config/config.sh"
        destination = "/home/ubuntu/config.sh"
    }

    provisioner "remote-exec" {
        inline = ["chmod +x /home/ubuntu/config.sh","/home/ubuntu/config.sh",]
    }
    
    provisioner "local-exec" {
        command = "scp -i ../${var.server-name}-connect/${var.server-name}.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${aws_eip.dh_ip.public_dns}:/home/ubuntu/client.config.yaml ../${var.server-name}-connect/client.config.yaml"

    }
}
