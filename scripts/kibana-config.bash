#!/bin/bash
# This script writes a config file for Kibana that points it to the IP address of
# the machine that is running Elasticsearch.

# Lookup the IP address of Elasticsearch, so we know where to point Kibana.
# TODO: Make this etcd endpoint dynamically assignable.  You can lookup `docker0` under
#       `ip address show` while on a CoreOS machine, but I'm having some trouble assigning it.
curl -L http://10.1.42.1:4001/v2/keys/dns/elasticsearch/host > temp.json
host=$(cat temp.json | jq -r '.node.value')

# Modify kibana.yml by adding the IP address of the Elasticsearch cluster.
cd /data/kibana/kibana-4.0.0-BETA1.1/config
sed s/localhost/$host/ kibana.yml > new.yml
mv new.yml kibana.yml


echo "Configuration Complete.  Kibana is pointed at \"http://$host:9200\""
echo " "
echo " "
echo "Staring Kibana 4 Service..."
/data/kibana/kibana-4.0.0-BETA1.1/bin/kibana
