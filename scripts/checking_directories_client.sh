#!/bin/bash -e
outputHandler "section" "Checking directories"
#create_folder_if_no_exist

checkFolderExistOrCreate "/home/$install_user/Sites"
if [ ! -e "/srv/sites" ]; then 
    ln -s /home/$install_user/Sites /srv/sites
fi
checkFolderExistOrCreate "/srv/sites/apache"
checkFolderExistOrCreate "/srv/sites/apache/logs"
checkFolderExistOrCreate "/srv/sites/parentnode"
checkFolderExistOrCreate "/srv/sites/apache/ssl"

outputHandler "comment" "Changing Folder rights from root to your curent user"
# Change Folder Rights from root to current user
chown -R $install_user:$install_user /srv/sites
