#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh

updateContent(){
    #sed '/#data/,/#enddata/ {s/./changed}' /srv/sites/parentnode/ubuntu_environment/tests/test_update_content/destination
    #sed -i 's/'--data'/'
    sed -i "/$1/,/$1/d" "$3" 
    readdata=$( < $2)
    echo "$readdata" | sed -n "/$1/,/$1/p" >> "$3"
}

updateContent "#parentnode: github" "/srv/sites/parentnode/ubuntu_environment/tests/test_update_content/source" "/srv/sites/parentnode/ubuntu_environment/tests/test_update_content/destination"