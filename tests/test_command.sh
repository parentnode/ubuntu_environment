#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh
# Check if program/service are installed
echo "Testing testCommand"
echo 
valid_status=("active" "inactive")
echo "Checking Apache2.4 status: "
testCommand "service apache2 status" "${valid_status[@]}"
echo
echo "Checking Redis status: "
testCommand "service redis status" "${valid_status[@]}"
echo
echo "Checking unzip version: "
valid_version=("^UnZip ([6\.[0-9])")
testCommand "unzip -v" "${valid_version[@]}"

# Usage: returns a true if a program or service are located in the installed services or programs
# P1: kommando
# P2: array of valid responses