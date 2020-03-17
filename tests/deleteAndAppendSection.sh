#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh

deleteAndAppendSection "#parentnode: github" "/srv/sites/parentnode/ubuntu_environment/tests/test_update_content/source" "/srv/sites/parentnode/ubuntu_environment/tests/test_update_content/destination"