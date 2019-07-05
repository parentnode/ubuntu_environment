#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh
# Function checkGitCredential
# Check if credential are set

#Usage: check if there is value in

#Git.username
checkGitCredential "name"
#Git.email
checkGitCredential "email"