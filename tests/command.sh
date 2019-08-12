#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh
#command "hostname"
#command "hostname" true
echo "$(command "hostname")"
echo "$(command "hostname" true)"
command "mkdir $HOME/Desktop/d1" true
