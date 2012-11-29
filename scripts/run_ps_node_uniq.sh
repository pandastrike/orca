#!/usr/bin/env bash

./run_ps_node.rb | awk '/coffee/' | sort | uniq -c

