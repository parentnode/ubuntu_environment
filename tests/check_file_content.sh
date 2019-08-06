#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh
#checkFileContent "alias" "$HOME/.bash_profile"
bash_profile_path="$HOME/.bash_profile"
echo "Checking File content: $(checkFileContent "git_prompt" "$bash_profile_path")"
#checkFileContent "git_prompt" "$HOME/.bash_profile"

if [ "$(checkFileContent "alias" "$bash_profile_path" )" = "true" ]; then
    echo "match found"
else 
    echo "match not found"
fi
