guiText(){
	# Automatic comments for simple setup as a gui
	# eg. guiText "Redis" "Starting"
	# $1 Name of object to process
	# $2 Type of process
	case $2 in 
		"Start")
			echo
			echo "Starting installation progress for $1"
			echo
			;;
		"Download")
			echo
			echo "Downloading files for the installation of $1"
			echo "This could take some time depending on your internet connection"
			echo "and hardware configuration"
			echo
			;;
		"Install")
			echo
			echo "Configuring installation for $1"
			echo
			;;
		"Replace")
			echo
			echo "Replacing $1 with $3"
			echo
			;;
		"Installed")
			echo
			echo "$1 Installed"
			echo
			;;
		"Enable")
			echo
			echo "Enabling $1"
			echo
			;;
		"Disable")
			echo
			echo "Disabling $2"
			echo
			;;
		"Done")
			echo
			echo "Installation process for $1 are done"
			echo
			;;
		"Skip")
			echo
			echo "Skipping Installation process for $1"
			echo
			;;
		*)
			echo
			echo "More info regarding $1 and $2 can be found on https://github.com/parentnode/ubuntu-environment"
			echo "and https://parentnode.dk"
			echo
			;;

	esac
	#if test $2 = "Start";
	#then
	#	echo
	#	echo "Starting installation progress for $1"
	#	echo
	#fi
#
	#if test $2 = "Download";
	#then
	#	echo
	#	echo "Downloading files for the installation of $1"
	#	echo "This could take some time depending on your internet connection"
	#	echo "and hardware configuration"
	#	echo
	#fi
	#if test $2 = "Install";
	#then
	#	echo
	#	echo "Configuring installation for $1"
	#	echo
	#fi
	#if test $2 = "Installed";
	#then 
	#	echo
	#	echo "Installation for $1 are allready complete"
	#	echo
	#fi
	#if test $2 = "Enable";
	#then 
	#	echo
	#	echo "Enabling $1"
	#	echo
	#fi
	#if test $2 = "Done";
	#then
	#	echo
	#	echo "Installation process for $1 are done"
	#	echo
	#fi
	#if test $2 ="Skip";
	#then 
	#	echo
	#	echo "Skipping Installation process for $1"
	#	echo
	#fi
#

}
export -f guiText

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