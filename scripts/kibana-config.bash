#!/bin/bash
# This script writes a config file for Kibana that points it to the IP address of
# the machine that is running Elasticsearch.

cat '# Kibana is served by a backend server. This controls which port to use.' > /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat 'port: 5601' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat ' ' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml

cat '# The Elasticsearch instance to use for all your queries' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat "elasticsearch: \"http://$1:9200\"" >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat ' ' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml

cat '# Kibana uses an index in Elasticsearch to store saved searches, visualizations' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat "# and dashboards. It will create an new index if it doesn't already exist." >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat 'kibanaIndex: "kibana-int"'  >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat ' ' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml

cat '# Applications loaded and included into Kibana. Use the settings below to' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat '# customize the applications and thier names.' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat 'apps:' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat '  - { id: "discover", name: "Discover" }' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat '  - { id: "visualize", name: "Visualize" }' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat '  - { id: "dashboard", name: "Dashboard" }' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat '  - { id: "settings", name: "Settings" }' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat ' ' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml

cat '# The default application to laad.' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
cat 'defaultAppId: "discover"' >> /data/kibana/kibana-4.0.0-BETA1.1/config/kibana.yml
