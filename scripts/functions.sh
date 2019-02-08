#!/bin/bash -e
guiText(){
	# Automatic comment format for simple setup as a text based gui
	# eg. guiText "Redis" "Start"
	# $1 Name of object to process
	# $2 Type of process
	case $2 in 
		"Link")
			echo
			echo
			echo "More info regarding $1"
			echo "can be found on $3"
			if [ -n "$4" ];
			then
				echo "and $4"
			fi
			echo
			echo
			;;
		"Comment")
			echo
			echo "$1:"
			echo
			;;
		"Section")
			echo
			echo 
			echo "{---$1---}"	
			echo
			echo
			;;
		#These following commentary cases are used for installing and configuring setup
		"Start")
			echo
			echo
			echo "Starting installation process for $1"
			echo
			echo
			;;
		"Download")
			echo
			echo "Downloading files for the installation of $1"
			echo "This could take some time depending on your internet connection"
			echo "and hardware configuration"
			echo
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
			echo "$1 Installed no need for installation at this point"
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
			echo
			echo "Installation process for $1 are done"
			echo
			echo
			;;
		"Skip")
			echo
			echo
			echo "Skipping Installation process for $1"
			echo
			echo
			;;
		*)
			echo 
			echo "Are you sure you wanted to use gui text here?"
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

trimString(){
	trim=$1
	echo "${trim}" | sed -e 's/^[ \t]*//'
}
export -f trimString
checkFileContent() 
{
	#dot_profile
	file=$1
	#bash_profile.default
	default=$2
	echo "Updating $file"
	# Splits output based on new lines
	IFS=$'\n'
	# Reads all of default int to an variable
	default=$( < "$default" )

	# Every key value pair looks like this (taken from bash_profile.default )
	# "alias mysql_grant" alias mysql_grant="php /srv/tools/scripts/mysql_grant.php"
	# The key komprises of value between the first and second quotation '"'
	default_keys=( $( echo "$default" | grep ^\" |cut -d\" -f2))
	# The value komprises of value between the third, fourth and fifth quotation '"'
	default_values=( $( echo "$default" | grep ^\" |cut -d\" -f3,4,5))
	unset IFS
	
	for line in "${!default_keys[@]}"
	do		
		# do dot_profile contain any of the keys in bash_profile.default
		check_for_key=$(grep -R "${default_keys[line]}" "$file")
		# if there are any default keys in dot_profile
		if [[ -n $check_for_key ]];
		then
			# Update the values connected to the key
			sed -i -e "s,${default_keys[line]}\=.*,$(trimString "${default_values[line]}"),g" "$file"
			
		fi
		
	done
	
}
export -f checkFileContent

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