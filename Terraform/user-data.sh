#!/bin/bash

# Stop Kibana
service kibana stop

# bind url to 0.0.0.0 for kibana.yml
line=$(echo "server.host:" \"0.0.0.0\")
echo $line >> /etc/kibana/kibana.yml

# Start Kibana
service kibana start
