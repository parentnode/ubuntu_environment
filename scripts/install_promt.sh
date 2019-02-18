#!/bin/bash -e

# ADD COMMANDS ALIAS'
#cat /srv/tools/conf-client/dot_bash_profile > /home/$install_user/.bash_profile
# Takes a string and removes leading and following tabs and spaces

if [ ! -f "$HOME/.bash_profile" ]; 
then
	guiText "parentnode terminal" "Install"
	sudo cp /srv/tools/conf-client/default_conf_complete /$HOME/.bash_profile
fi

updateStatementInFile "enable git prompt" "srv/tools/conf-client/default_conf_complete" "$HOME/.bash_profile"
updateStatementInFile "alias" "srv/tools/conf-client/default_conf_complete" "$HOME/.bash_profile"
#checkAlias "/home/$install_user/.bash_profile" "/srv/tools/conf-client/dot_bash_profile"


#checkStringInFile "export PS1" "$HOME/.bash_profile"


install_bash_profile=$(grep -E ". $HOME/.bash_profile" /$HOME/.bashrc || echo "")
#install_bash_profile=$(grep -E "\$HOME\/\.bash_profile" /home/$install_user/.bashrc || echo "")
if [ -z "$install_bash_profile" ]; then
	guiText ".bash_profile" "Install" ".bashrc"
	# Add .bash_profile to .bashrc
	echo
	echo "if [ -f \"$HOME/.bash_profile\" ]; then" >> /$HOME/.bashrc
	echo " . $HOME/.bash_profile" >> $HOME/.bashrc
	echo "fi" >> $HOME/.bashrc
else
	guiText ".bash_profile" "Installed"
fi
