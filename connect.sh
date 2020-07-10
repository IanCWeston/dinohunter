#! /bin/bash

#################################################
# SSH and Portforward for kibana and velociraptor
#################################################

echo "What is the public dns of the server you are trying to connect to?"

read dns_name

echo "Connecting now..."

ssh -i terraform/elk-server.pem -L 5601:localhost:5601 -L 8889:localhost:8889 ubuntu@$dns_name

