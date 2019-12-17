#!/bin/bash -e
outputHandler "section" "Checking directories"
#create_folder_if_no_exist

outputHandler "section" "Checking directories"
## MAKE SITES FOLDER
checkFolderExistOrCreate "/srv/sites"
## MAKE CONF FOLDER
checkFolderExistOrCreate "/srv/conf"
