#!/bin/bash -e

# ADD COMMANDS ALIAS'
#cat /srv/tools/conf-client/dot_bash_profile > /home/$install_user/.bash_profile
# Takes a string and removes leading and following tabs and spaces

#if [ ! -f "$HOME/.bash_profile" ]; 
#then
#	guiText "parentnode terminal" "Install"
#	sudo cp /srv/tools/conf-client/default_conf_complete /$HOME/.bash_profile
#fi
guiText "Existing .bash_profile" "Replace" "parentnode promt"
does_parentnode_git_exist=$(grep -E "enable_git_prompt" $HOME/.bash_profile || echo "")
does_parentnode_alias_exist=$(grep -E "alias" $HOME/.bash_profile || echo "")
if [ -z "$does_parentnode_git_exist" ] || [ -z "$does_parentnode_alias_exist" ];
then
	sudo cp /srv/tools/conf-client/default_conf_complete /$HOME/.bash_profile
else
	updateStatementInFile "enable_git_prompt" "/srv/tools/conf-client/default_conf_complete" "$HOME/.bash_profile"
	updateStatementInFile "alias" "/srv/tools/conf-client/default_conf_complete" "$HOME/.bash_profile"
fi
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
