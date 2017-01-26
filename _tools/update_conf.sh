#!/bin/bash

echo "-----------------------------------------"
echo
echo "       UPDATING VIRTUAL HOST CONF"
echo
echo

cd /srv/conf && sudo git pull
