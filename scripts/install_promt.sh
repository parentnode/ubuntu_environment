#!/bin/bash -e

# ADD COMMANDS ALIAS'
#cat /srv/tools/conf-client/dot_bash_profile > /home/$install_user/.bash_profile
# Takes a string and removes leading and following tabs and spaces
guiText ".bash profile are loaded in to your promt when you start ubuntu" \
"Comment" \
"when this installer are done it will change color and when you are entering an git repository"


if [ ! -f "$HOME/.bash_profile" ]; 
then
	guiText "parentnode terminal" "Install"
	cp /srv/tools/conf-client/default_conf_complete /$HOME/.bash_profile
fi

checkFileContent "/home/$install_user/.bash_profile" "/srv/tools/conf-client/dot_bash_profile"

install_bash_profile=$(grep -E "\$HOME\/\.bash_profile" /home/$install_user/.bashrc || echo "")
if [ -z "$install_bash_profile" ]; then

	# Add .bash_profile to .bashrc
	echo
	echo "if [ -f \"\$HOME/.bash_profile\" ]; then" >> /home/$install_user/.bashrc
	echo " . \"\$HOME/.bash_profile\"" >> /home/$install_user/.bashrc
	echo "fi" >> /home/$install_user/.bashrc
fi
