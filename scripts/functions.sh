#checkPath()
#{
#	path=$1	
#	if [ ! -d "$path" ]; then
#		mkdir $path
#	else 
#		echo "Allready Exist"
#	fi
#}
#export checkPath

# Checks if a folder exists if not it will be created
checkFolderOrCreate(){
	folderName=$1
	if [ -e $folderName ];
	then
		echo "$folderName already exists"
	else 
		echo "Creating directory $folderName"
    	mkdir -p $folderName;
	fi
	echo ""
}
export -f checkFolderOrCreate

# Setting Git credentials if needed
git_configured(){
	git_credential=$1
	credential_configured=$(git config --global user.$git_credential || echo "")
	if [ -z "$credential_configured" ];
	then 
		echo "No previous git user.$git_credential entered"
		echo
		read -p "Enter your new user.$git_credential: " git_new_value
		git config --global user.$git_credential "$git_new_value"
		echo
	else 
		echo "Git user.$git_credential allready set"
	fi
	echo ""
}
export -f git_configured