#!/bin/bash
###########################
# Set status of install
###########################
touch /home/ubuntu/Starting_Installation.txt

###########################
# Update and Upgrade
###########################
mv /home/ubuntu/Starting_Installation.txt /home/ubuntu/Update_Upgrade.txt
apt-get update -y && apt-get upgrade -y

###########################
# Elasticsearch
###########################
mv /home/ubuntu/Update_Upgrade.txt /home/ubuntu/Installing_Elasticsearch.txt
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
mv /home/ubuntu/Installing_Elasticsearch.txt /home/ubuntu/Installing_Kibana.txt
apt-get update && apt-get install kibana
/bin/systemctl daemon-reload
/bin/systemctl enable kibana.service
service kibana start

###########################
# Filebeat
###########################
mv /home/ubuntu/Installing_Kibana.txt /home/ubuntu/Installing_Filebeat.txt
apt-get update && apt-get install filebeat

###########################
# Velociraptor
###########################
mv /home/ubuntu/Installing_Filebeat.txt /home/ubuntu/Installing_Velociraptor.txt
cd /opt
wget https://github.com/Velocidex/velociraptor/releases/download/v0.4.5/velociraptor-v0.4.5-linux-amd64
chmod +x velociraptor-v0.4.5-linux-amd64
/opt/velociraptor-v0.4.5-linux-amd64 config generate >> /opt/server.config.yaml
/opt/velociraptor-v0.4.5-linux-amd64 --config server.config.yaml user add admin --role=administrator admin
/opt/velociraptor-v0.4.5-linux-amd64 --config /opt/server.config.yaml frontend &

mv /home/ubuntu/Installing_Velociraptor.txt /home/ubuntu/Installation_Complete.txt