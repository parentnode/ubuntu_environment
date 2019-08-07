#!/bin/bash -e
source /srv/sites/parentnode/ubuntu_environment/scripts/functions.sh

syncronizeAlias "/srv/sites/parentnode/ubuntu_environment/tests/test_syncronize_alias/source" "/srv/sites/parentnode/ubuntu_environment/tests/test_syncronize_alias/destination"
