#!/bin/bash

echo "-----------------------------------------"
echo
echo "            UPDATING SERVER"
echo
echo


if [[ $(systemctl list-unit-files mattermost.service &>/dev/null && echo "exists" || echo "") ]]; then
	sudo systemctl stop mattermost
fi


sudo apt update
sudo apt upgrade
sudo apt-get autoremove


if [[ $(systemctl list-unit-files mattermost.service &>/dev/null && echo "exists" || echo "") ]]; then
	sudo systemctl start mattermost
fi
