terraform {
    required_version = ">= 0.12"
}

provider "aws" {
    region = var.aws-region # Default us-east-1
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

resource "aws_instance" "elk-server" {
    ami = "${data.aws_ami.packer-elk.id}"
    instance_type = var.server-size # Default t2.large

    tags = {
        Name = "ELK-Server"
    }
}

