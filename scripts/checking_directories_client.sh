#!/bin/bash -e
outputHandler "section" "Checking directories"
#create_folder_if_no_exist

checkFolderExistOrCreate "/home/$install_user/Sites"

if [ ! -e "/srv/sites" ]; then 
    ln -s /home/$install_user/Sites /srv/sites
else
    outputHandler "comment" "Symlink"
    sites_symlink_exists=$(ls -Fla /srv | grep /home/ | cut -d \/ -f3)
    if [ "$sites_symlink_exists" = "$install_user"  ]; then
        outputHandler "comment" "Symlink belongs to $install_user" "No need for creating a symlink"
    else
        rm /srv/sites
        ln -s /home/$install_user/Sites /srv/sites
    fi

fi
checkFolderExistOrCreate "/srv/sites/apache"
checkFolderExistOrCreate "/srv/sites/apache/logs"
checkFolderExistOrCreate "/srv/sites/parentnode"
checkFolderExistOrCreate "/srv/sites/apache/ssl"

outputHandler "comment" "Changing Folder rights from root to your curent user"
# Change Folder Rights from root to current user
sudo chown -R $install_user:$install_user /home/$install_user/Sites