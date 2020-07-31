#!/bin/bash
###########################
# Set status of install
###########################
touch /home/ubuntu/dh-install.log

###########################
# Update and Upgrade
###########################
echo "$(date +'%b %d %T'): starting install" >> /home/ubuntu/dh-install.log
apt-get update -y && apt-get upgrade -y

###########################
# Elasticsearch
###########################
echo "$(date +'%b %d %T'): installing Elasticsearch" >> /home/ubuntu/dh-install.log
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
echo "$(date +'%b %d %T'): installing Kibana" >> /home/ubuntu/dh-install.log
apt-get update && apt-get install kibana
/bin/systemctl daemon-reload
/bin/systemctl enable kibana.service
service kibana start

###########################
# Filebeat
###########################
echo "$(date +'%b %d %T'): installing Filebeat" >> /home/ubuntu/dh-install.log
apt-get update && apt-get install filebeat

###########################
# Velociraptor
###########################

#Determine the latest version number
echo "$(date +'%b %d %T'): installing Velociraptor" >> /home/ubuntu/dh-install.log
cd /opt
RELEASE=$(curl -s https://api.github.com/repos/Velocidex/velociraptor/releases/latest \
| grep "tag_name" \
| awk '{print substr($2, 2, length($2)-3)}') 

#Download the latest release of Velociraptor
wget https://github.com/Velocidex/velociraptor/releases/download/$RELEASE/velociraptor-$RELEASE-linux-amd64
chmod +x velociraptor-$RELEASE-linux-amd64

# Get the public dns name
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` 
URL=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/public-hostname`

#Configure the Server and Client configs
/opt/velociraptor-$RELEASE-linux-amd64 config generate >> /opt/server.config.yaml --merge '{"Client":{"server_urls":["https://'$URL':8000/"],"use_self_signed_ssl":true},"API":{"hostname":"'$URL'"},"Frontend":{"hostname":"'$URL'"}}' 
/opt/velociraptor-$RELEASE-linux-amd64 --config /opt/server.config.yaml config client >> /opt/client.config.yaml

#Add the admin user and start the front end in the background
/opt/velociraptor-$RELEASE-linux-amd64 --config /opt/server.config.yaml user add admin --role=administrator admin
/opt/velociraptor-$RELEASE-linux-amd64 --config /opt/server.config.yaml frontend &
cp /opt/client.config.yaml /home/ubuntu/client.config.yaml
chown ubuntu /home/ubuntu/client.config.yaml


echo "$(date +'%b %d %T'): instalation complete: your server is now ready for use" >> /home/ubuntu/dh-install.log
