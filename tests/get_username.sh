#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh
echo ""
echo "Get username test"
echo ""

username="$(getUsername)"
echo "Current user is: $username"