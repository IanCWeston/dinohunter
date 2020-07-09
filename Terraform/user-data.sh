#!/bin/bash

###########################
# Update and Upgrade
###########################
apt-get update -y && apt-get upgrade -y

###########################
# Elasticsearch
###########################

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt-get update && apt-get install elasticsearch
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service
service elasticsearch start

###########################
# Kibana
###########################

apt-get update && apt-get install kibana
/bin/systemctl daemon-reload
/bin/systemctl enable kibana.service
line=$(echo "server.host:" \"0.0.0.0\")
echo $line >> /etc/kibana/kibana.yml
service kibana start

###########################
# Filebeat
###########################

apt-get update && apt-get install filebeat

###########################
# Velociraptor
###########################

cd /opt
wget https://github.com/Velocidex/velociraptor/releases/download/v0.4.5/velociraptor-v0.4.5-linux-amd64
chmod +x velociraptor-v0.4.5-linux-amd64