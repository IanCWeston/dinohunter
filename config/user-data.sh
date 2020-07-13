#!/bin/bash
###########################
# Set status of install
###########################
touch /home/ubuntu/elk-vr-install.log

###########################
# Update and Upgrade
###########################
echo "$(date): starting install" >> /home/ubuntu/elk-vr-install.log
apt-get update -y && apt-get upgrade -y

###########################
# Elasticsearch
###########################
echo "$(date): installing  Elasticsearch" >> /home/ubuntu/elk-vr-install.log
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
echo "$(date): installing Kibana" >> /home/ubuntu/elk-vr-install.log
apt-get update && apt-get install kibana
/bin/systemctl daemon-reload
/bin/systemctl enable kibana.service
service kibana start

###########################
# Filebeat
###########################
echo "$(date): installing Filebeat" >> /home/ubuntu/elk-vr-install.log
apt-get update && apt-get install filebeat

###########################
# Velociraptor
###########################
echo "$(date): installing Velociraptor" >> /home/ubuntu/elk-vr-install.log
cd /opt
wget https://github.com/Velocidex/velociraptor/releases/download/v0.4.5/velociraptor-v0.4.5-linux-amd64
chmod +x velociraptor-v0.4.5-linux-amd64
/opt/velociraptor-v0.4.5-linux-amd64 config generate >> /opt/server.config.yaml
/opt/velociraptor-v0.4.5-linux-amd64 --config server.config.yaml user add admin --role=administrator admin
/opt/velociraptor-v0.4.5-linux-amd64 --config /opt/server.config.yaml frontend &

echo "$(date): instalation complete: your server is now ready for use" >> /home/ubuntu/elk-vr-install.log
