#!/bin/bash
# This script writes a config file for Kibana that points it to the IP address of
# the machine that is running Elasticsearch.

cd /data/kibana/kibana-4.0.0-BETA1.1/config

echo '# Kibana is served by a backend server. This controls which port to use.' > kibana.yml
echo 'port: 5601' >> kibana.yml
echo ' ' >> kibana.yml

echo '# The Elasticsearch instance to use for all your queries' >> kibana.yml
echo "elasticsearch: \"http://$1:9200\"" >> kibana.yml
echo ' ' >> kibana.yml

echo '# Kibana uses an index in Elasticsearch to store saved searches, visualizations' >> kibana.yml
echo "# and dashboards. It will create an new index if it doesn't already exist." >> kibana.yml
echo 'kibanaIndex: "kibana-int"'  >> kibana.yml
echo ' ' >> kibana.yml

echo '# Applications loaded and included into Kibana. Use the settings below to' >> kibana.yml
echo '# customize the applications and thier names.' >> kibana.yml
echo 'apps:' >> kibana.yml

echo '  - { id: "discover", name: "Discover" }' >> kibana.yml
echo '  - { id: "visualize", name: "Visualize" }' >> kibana.yml
echo '  - { id: "dashboard", name: "Dashboard" }' >> kibana.yml
echo '  - { id: "settings", name: "Settings" }' >> kibana.yml

echo '# The default application to laad.' >> kibana.yml
echo 'defaultAppId: "discover"' >> kibana.yml

echo "Configuration Complete."
