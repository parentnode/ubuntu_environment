#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh

installCommand(){
    echo "Executing command $1"
    install_cmd=$($1)
    if [ "$install_cmd" ]; then
        echo "$1 executed perfectly"
    else 
        echo "There where errorsd"
        echo "$1"
    fi
    
}

installCommand "sudo apt install -y apache2"