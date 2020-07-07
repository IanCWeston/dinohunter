#!/bin/bash

# Run commands with root permission
sudo su

###########################
# Elasticsearch
###########################

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt-get update && apt-get install elasticsearch
sleep 5
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service

###########################
# Kibana
###########################

apt-get update && apt-get install kibana
sleep 5
/bin/systemctl daemon-reload
/bin/systemctl enable kibana.service

###########################
# Filebeat
###########################

apt-get update && apt-get install filebeat

# Return to user
exit
