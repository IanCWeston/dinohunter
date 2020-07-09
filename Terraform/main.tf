terraform {
    required_version = ">= 0.12"
}

provider "aws" {
    region      = var.aws-region # Default us-east-1
    profile     = var.aws-cli-profile # Defaults to empty string
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

    
    egress {
        from_port   = local.any_port
        to_port     = local.any_port
        protocol    = local.any_protocol
        cidr_blocks = local.all_ips
    }

    tags = {
        Name = "ELK_server"
    }

}

# Call for Packer created AMI
data "aws_ami" "packer-elk" {
    most_recent = true
    owners  = ["self"]

    filter {
        name = "name"
        values = ["packer-elk*"]
    }

    filter {
        name = "tag:PackerProvisioned"
        values = ["1"]
    }  
}

# Create instance from Packer AMI, provide tag Name: ELK-Server and attached to new security group
resource "aws_instance" "elk_vr-server" {
    ami = data.aws_ami.packer-elk.id
    instance_type = var.server-size # Default t2.large

    vpc_security_group_ids = [aws_security_group.allow-elk_vr-server.id]

    tags = {
        Name = "ELK-VR-Server"
    }

# Add custom bootstrap script to configure Kibana
    user_data = file("./user-data.sh")

}

