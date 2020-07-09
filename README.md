# aws-elk-velociraptor

[![CodeFactor](https://www.codefactor.io/repository/github/iancweston/aws-elk-velociraptor/badge)](https://www.codefactor.io/repository/github/iancweston/aws-elk-velociraptor)

*Please note: This project is still in pre-release and may not behave as expected*

The goal of this project is to aid Incident Responders with large scale investigations and quickly spin up a temporary Velociraptor and Elastic Stack server in AWS. This solution can act as a "historical" SIEM when no SIEM was present during a compromise. Velociraptor will query the endpoints and can pipe the data into the Elastic Stack for analysis.

## To do list
- [x] Create Packer script to generate AMI
- [ ] Create Terraform script that uses the generated AMI
- [ ] Automate the configuration of Kibana Authentication/Security
- [ ] Automate the Velociraptor server configuration
- [ ] Automate the Velociraptor client configuration
- [ ] Automate the Filebeat module configuration for Office365

## Velociraptor
[Velociraptor](https://www.velocidex.com/) is a Digital Forensics and Incident Response (DFIR) tool that allows investigators to "dig deeper" at scale. 
### Benefits
* A single server can handle environments of up to 10,000 endpoints.
* You can parse forensic artifacts on the fly ($MFT, amcache, prefetch, etc)
* Data can be viewed in the Velociraptor GUI or can be sent to the Elastic Stack for dashboarding and visualization

## The Elastic Stack 
[The Elastic Stack](https://www.elastic.co/elastic-stack?ultron=[EL]-[B]-[Stack]-[Trials]-[AMER]-[US-C]-Exact&gambit=Elasticsearch-ELK&blade=adwords-s&thor=elastic%20stack&gclid=EAIaIQobChMIhPmZjq6_6gIVAuDICh00QwikEAAYASAAEgKaw_D_BwE) is a data analysis platform that can ingest many forms of data in large volumes and present it in a way that is easily analyzed.

### Benefits
* Speed of querying
* Visualizations
* Dashboards
* Can handle a large amount of data

## Prerequisites
* The following software installed on your comptuer:
  * [Packer](https://www.packer.io/downloads) installed and added to PATH
  * [Terraform](https://www.terraform.io/downloads.html) installed and added to PATH
 * AWS IAM User with the below minimum permissions for Packer and Terraform

 ### Packer Minimum Permissions
 ```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CopyImage",
        "ec2:CreateImage",
        "ec2:CreateKeypair",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteKeyPair",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSnapshot",
        "ec2:DeleteVolume",
        "ec2:DeregisterImage",
        "ec2:DescribeImageAttribute",
        "ec2:DescribeImages",
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeRegions",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSubnets",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:GetPasswordData",
        "ec2:ModifyImageAttribute",
        "ec2:ModifyInstanceAttribute",
        "ec2:ModifySnapshotAttribute",
        "ec2:RegisterImage",
        "ec2:RunInstances",
        "ec2:StopInstances",
        "ec2:TerminateInstances"
      ],
      "Resource": "*"
    }
  ]
}
```

### Terraform Minimum Permissions
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:PLACEHOLDER
      ],
      "Resource": "*"
    }
  ]
}
```
## Usage Instructions
### Packer
On occaision (every month should be enough) run the following packer command to build a new AMI so that all software is up to date. Packer will install Elasticsearch, Kibana, Filebeat, and 

`packer build ./template.json`

### Terraform
To stand up new infrastructure use the following commands:

* Initialize the directory with - `terraform init` 

* Make sure everything looks good with - `terraform plan`

* Create the infrastructure with - `terraform apply`

### Configure Velociraptor Server
Place holder instructions

### Configure Velociraptor Agents
Place holder instructions

### Configure Velociraptor to send data to the Elasticstack
Place holder instructions

### Configure Indexes in Kibana
Place holder instructions
