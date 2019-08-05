#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh
if [ "$(fileExists "$HOME/.bash_profile")" = "true" ]; then 
    echo "file exists"
else
    echo "file do not exists"
fi

