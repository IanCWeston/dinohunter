#!/bin/bash

###########################
# Update and Upgrade
###########################
sudo apt-get update -y && sudo apt-get upgrade -y

###########################
# Elasticsearch
###########################

sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
sudo echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install elasticsearch
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

###########################
# Kibana
###########################

sudo apt-get update && sudo apt-get install kibana
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable kibana.service

###########################
# Filebeat
###########################

sudo apt-get update && sudo apt-get install filebeat
