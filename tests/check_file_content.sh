#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh
checkFileContent "git_prompt" "$HOME/.bash_profile"
checkFileContent "alias" "$HOME/.bash_profile"

