#!/usr/bin/env bash

set -x

mkdir -p /etc/orca/

cat << EOF > /etc/orca/environment.cson
api:
  service_url: "http://orca1-lead1.pandastrike.com"
  port: 80
mongo:
  host: "orca1-lead1.pandastrike.com"
  port: 27017
  database: "orca"
redis:
  host: "orca1-lead1.pandastrike.com"
  port: 6379
EOF

