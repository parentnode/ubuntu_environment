#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh
# Check if program/service are installed
echo "Testing testCommandResponse"
echo 
valid_status=("running" "dead")
echo "Checking Apache2.4 status: "
testCommandResponse "service apache2 status" "${valid_status[@]}"
echo
echo "Checking Redis status: "
testCommandResponse "service redis status" "${valid_status[@]}"
echo
echo "Checking unzip version: "
valid_version=("^UnZip ([6\.[0-9])")
testCommandResponse "unzip -v" "${valid_version[@]}"

# Usage: returns a true if a program or service are located in the installed services or programs
# P1: kommando
# P2: array of valid responses