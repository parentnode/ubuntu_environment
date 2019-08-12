#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh

command(){
    if [[ $2 == true ]]; then
        echo "no echo: $1" 
        cmd=$($1 &>/dev/null)
    else
        echo "echo: $1"
        cmd=$($1)
    fi
    echo "$cmd"
}
export -f command
#command "hostname"
#command "hostname" true
echo "$(command "hostname")"
echo "$(command "hostname" true)"