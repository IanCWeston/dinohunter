# DinoHunter

[![CodeFactor](https://www.codefactor.io/repository/github/iancweston/dinohunter/badge)](https://www.codefactor.io/repository/github/iancweston/dinohunter)

*Please note: This project is still in pre-release and may not behave as expected*

The goal of DinoHunter is to aid Incident Responders with large scale investigations and quickly spin up a temporary Velociraptor and Elastic Stack server in AWS. This solution can act as a "historical" SIEM when no SIEM was present during a compromise. Velociraptor will query the endpoints and can pipe the data into the Elastic Stack for analysis.

## To do list

- [X] Create Terraform script that launches the infrastructure
- [X] Automate the Velociraptor server configuration
- [ ] Automate the Velociraptor client configuration
- [ ] Automate the Filebeat module configuration for Office365

## Velociraptor

[Velociraptor](https://www.velocidex.com/) is a Digital Forensics and Incident Response (DFIR) tool that allows investigators to "dig deeper" at scale.

### Velociraptor Benefits

- A single server can handle environments of up to 10,000 endpoints.
- You can parse forensic artifacts on the fly ($MFT, amcache, prefetch, etc)
- Data can be viewed in the Velociraptor GUI or can be sent to the Elastic Stack for dashboarding and visualization

## The Elastic Stack

[The Elastic Stack](https://www.elastic.co/elastic-stack?ultron=[EL]-[B]-[Stack]-[Trials]-[AMER]-[US-C]-Exact&gambit=Elasticsearch-ELK&blade=adwords-s&thor=elastic%20stack&gclid=EAIaIQobChMIhPmZjq6_6gIVAuDICh00QwikEAAYASAAEgKaw_D_BwE) is a data analysis platform that can ingest many forms of data in large volumes and present it in a way that is easily analyzed.

### Elastic Stack Benefits

- Speed of querying
- Visualizations
- Dashboards
- Can handle a large amount of data

## Prerequisites

- The following software installed on your comptuer:
  - [Terraform](https://www.terraform.io/downloads.html) installed and added to PATH
  - AWS IAM User with the below minimum permissions for Terraform

### Terraform Minimum Permissions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:PLACEHOLDER"
      ],
      "Resource": "*"
    }
  ]
}
```

## Usage Instructions

### Terraform

To stand up new infrastructure use the following commands:

- Change into the terraform directory and execute the following commands:

  - Initialize the directory with - `terraform init`

  - Make sure everything looks good with - `terraform plan`

  - Create the infrastructure with - `terraform apply`
  - Note the dns name that is listed when it completes

### Connect to the new server

- Execute - `../connect/connect.sh`
- As long as this SSH session is open you can access the Kibana and Velociraptor front ends at:
  - [Kibana](http://localhost:5601 "http://localhost:5601")
  - [Velociraptor](https://localhost:8889 "https://localhost:8889")
- Once connected you can `tail -f` the `/home/ubuntu/dh-install.log` file to quickly see the status of the installation. Wait to connect to the front ends until you see ```instalation complete: your server is now ready for use``` in the file.

### Configure Velociraptor Server

Place holder instructions

### Configure Velociraptor Agents

Place holder instructions

### Configure Velociraptor to send data to the Elasticstack

Place holder instructions

### Configure Indexes in Kibana

Place holder instructions
