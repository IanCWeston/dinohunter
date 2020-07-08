terraform {
    required_version = ">= 0.12"
}

provider "aws" {
    region = var.aws-region # Default us-east-1
}

# Security group for the ELK Server
resource "aws_security_group" "allow-elk-server" {
    name = "ELK_server"
    description = "Allow ELK/SSH ports inbound"

    ingress {
        description  = "Allow SSH"
        from_port = 22
    }

    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

# Call for Packer created AMI
data "aws_ami" "packer-elk" {
    most_recent = true

    filter {
        name = "name"
        values = ["packer-elk*"]
    }

    filter {
        name = "tag:PackerProvisioned"
        values = ["true"]
    }
    
    owners = ["self"]
}

# Create instance from Packer AMI and provide tag Name: ELK-Server
resource "aws_instance" "elk-server" {
    ami = data.aws_ami.packer-elk.id
    instance_type = var.server-size # Default t2.large

    tags = {
        Name = "ELK-Server"
    }
}


