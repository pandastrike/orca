#!/usr/bin/env bash

set -x

# Target OS: Any *nix
# Install Orca


pushd /usr/local/
  git clone git@github.com:dyoder/orca.git
  cd orca
  npm install
popd


# Run Orca
# ./bin/lead config/example.cson
# ./bin/node foo

