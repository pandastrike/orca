#!/bin/bash
# This script writes a config file for Kibana that points it to the IP address of
# the machine that is running Elasticsearch.

cd /data/kibana/kibana-4.0.0-BETA1.1/config

cat '# Kibana is served by a backend server. This controls which port to use.' > kibana.yml
cat 'port: 5601' >> kibana.yml
cat ' ' >> kibana.yml

cat '# The Elasticsearch instance to use for all your queries' >> kibana.yml
cat "elasticsearch: \"http://$1:9200\"" >> kibana.yml
cat ' ' >> kibana.yml

cat '# Kibana uses an index in Elasticsearch to store saved searches, visualizations' >> kibana.yml
cat "# and dashboards. It will create an new index if it doesn't already exist." >> kibana.yml
cat 'kibanaIndex: "kibana-int"'  >> kibana.yml
cat ' ' >> kibana.yml

cat '# Applications loaded and included into Kibana. Use the settings below to' >> kibana.yml
cat '# customize the applications and thier names.' >> kibana.yml
cat 'apps:' >> kibana.yml
cat '  - { id: "discover", name: "Discover" }' >> kibana.yml
cat '  - { id: "visualize", name: "Visualize" }' >> kibana.yml
cat '  - { id: "dashboard", name: "Dashboard" }' >> kibana.yml
cat '  - { id: "settings", name: "Settings" }' >> kibana.yml
cat ' ' >> kibana.yml

cat '# The default application to laad.' >> kibana.yml
cat 'defaultAppId: "discover"' >> kibana.yml
