#!/bin/bash -e
outputHandler "section" "Checking directories"
#create_folder_if_no_exist


checkFolderExistOrCreate "/home/$install_user/Sites"
#checkFolderExistOrCreate "/home/$install_user/Sites/parentnode"
#checkFolderExistOrCreate "/srv"
#checkFolderExistOrCreate "/srv/sites"
#sites_symlink_exists=$(ls -Fla /srv/sites | grep /home/ | cut -d \/ -f3)
#
#if [ ! -e "/srv/sites/parentnode" ]; then 
#    ln -s /home/$install_user/Sites/parentnode /srv/sites/parentnode
#else
#    outputHandler "comment" "Symlink"
#    #sites_symlink_exists=$(ls -Fla /srv | grep /home/ | cut -d \/ -f3)
#    if [ "$sites_symlink_exists" = "$install_user"  ]; then
#        outputHandler "comment" "Symlink belongs to $install_user" "No need for creating a symlink"
#    else
#        rm /srv/sites/parentnode
#        ln -s /home/$install_user/Sites/parentnode /srv/sites/parentnode
#    fi
#
#fi
if [ ! -e /srv/sites ]; then
     ln -s /home/$install_user/Sites /srv/sites
fi
checkFolderExistOrCreate "/srv/sites/apache"
checkFolderExistOrCreate "/srv/sites/apache/logs"
checkFolderExistOrCreate "/srv/sites/parentnode"
checkFolderExistOrCreate "/srv/sites/apache/ssl"

outputHandler "comment" "Changing Folder rights from root to your curent user"
# Change Folder Rights from root to current user
sudo chown -R $install_user:$install_user /srv/sites