#!/usr/bin/env bash

set -x

mkdir -p /etc/orca/

cat << EOF > /etc/orca/test.cson
name: "si_events"
description: "Logging an event against the SI Events API"
quorum: 10
repeat: 8
step: 10
timeout: 5000 # 5 seconds
package:
  reference: "http://github.com/dyoder/orca-test/tarball/master"
  name: "orca-test"
options:
  service:
    url: "http://api.pandastrike.com"
EOF

