#!/bin/bash

# Stop Kibana
service kibana stop

# Add unique public DNS to kibana.yml
public_hostname=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-hostname)
line=$(echo "server.host:" \"$public_hostname\")
echo $line >> /etc/kibana/kibana.yml

# Start Kibana
service kibana start
