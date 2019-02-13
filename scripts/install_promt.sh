#!/bin/bash -e

# ADD COMMANDS ALIAS'
#cat /srv/tools/conf-client/dot_bash_profile > /home/$install_user/.bash_profile
# Takes a string and removes leading and following tabs and spaces

if [ ! -f "$HOME/.bash_profile" ]; 
then
	guiText "parentnode terminal" "Install"
	cp /srv/tools/conf-client/default_conf_complete /$HOME/.bash_profile
fi

checkFileContent "/home/$install_user/.bash_profile" "/srv/tools/conf-client/dot_bash_profile"


install_bash_profile=$(grep -E "if [ -f \"$HOME/.bash_profile\" ]; then \. \"$HOME/.bash_profile\" fi" /$HOME/.bashrc || echo "")
#install_bash_profile=$(grep -E "\$HOME\/\.bash_profile" /home/$install_user/.bashrc || echo "")
if [ -z "$install_bash_profile" ]; then

	# Add .bash_profile to .bashrc
	echo
	echo "if [ -f \"$HOME/.bash_profile\" ]; then" >> /$HOME/.bashrc
	echo " \. $HOME/.bash_profile" >> $HOME/.bashrc
	echo "fi" >> $HOME/.bashrc
fi
