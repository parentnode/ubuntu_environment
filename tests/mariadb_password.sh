#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh
echo "Testing if mariadb password is set"
if [[ "$(checkMariadbPassword)" == "true" ]]; then
    echo "Existing password found"
else
    echo "Password not set"
fi