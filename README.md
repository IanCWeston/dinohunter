# aws-elk-velociraptor

## Workflow Process

1. Create AMI (Packer)
    * Pass shell script to configure AMI
    * Add unique tag/s
    * Shell script
      * Needs to update repos & install upgrades
      * Install ELK & Velociraptor from public location
      * Set ELK & VR services to auto-start
      * Start ELK & VR services

2. Create Network (Terraform)
    * VPC
    * Subnet/s
    * Internet gateway
    * Route table
    * Should probably use AWS VPC module

3. Create Server/s with Packer AMI (Terraform)
    * Filter for AMI tag
    * Need to determine instance sizing

4. Create Security group for external access (Terraform)
   * SSH
   * ICMP
   * 5601
   * 8889
   * 8000

5. Output public DNS address/s of created server/s (Terraform)

Need way to delete the AMI after usage

## Things to Add later

* Security for Kibana
* Add Filebeat for O365 queries

### Minimum AWS IAM Permissions

### Usage Instructions

#### Prerequisites

* Packer installed and added to PATH
* Terraform installed and added to PATH
