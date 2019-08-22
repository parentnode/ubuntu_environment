#!/bin/bash -e
outputHandler "section" "Checking directories"
#create_folder_if_no_exist
checkFolderExistOrCreate "/srv/sites"
checkFolderExistOrCreate "/srv/sites/apache"
checkFolderExistOrCreate "/srv/sites/apache/logs"
checkFolderExistOrCreate "/srv/sites/parentnode"

outputHandler "comment" "Changing Folder rights from root to your curent user"
# Change Folder Rights from root to current user
chown -R $SUDO_USER:$SUDO_USER /srv/sites
