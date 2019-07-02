#!/bin/bash -e

# Get username for current user, display and store for later use
getUsername(){
	echo "$SUDO_USER"
}
export -f getUsername

# Invoke sudo command
enableSuperCow(){
	sudo ls &>/dev/null
}
export -f enableSuperCow

# Helper function for text output and format 
outputHandler(){
	#$1 - type eg. Comment, Section, Exit
	#$2 - text for output
	#$3,4,5 are extra text when needed
	case $1 in 
		"Comment")
			echo
			echo "$2"
			if [ -n "$3" ];
			then
				echo "$3"
			fi
			if [ -n "$4" ];
			then
				echo "$4"
			fi
			if [ -n "$5" ];
			then
				echo "$5"
			fi
			if [ -z "$2" ];
			then
				echo "No comments"
			fi
			echo
			;;
		"Section")
			echo
			echo 
			echo "{---$2---}"	
			echo
			echo
			;;
		"Exit")
			echo
			echo "$2 -- Goodbye see you soon"
			exit 0
			;;
		#These following commentary cases are used for installing and configuring setup
		*)
			echo 
			echo "Are you sure you wanted output here can't recognize: ($1)"
			echo
			;;

	esac
}
export -f outputHandler

# Asking user for input based on type
ask(){
	#$1 - output query text for knowing what to ask for.
	#$2 - array of valid chacters:
	#$3 - type eg. Password
	# If type is:  
	## Password hide prompt input, allow special chars, allow min and max length for the string 
	## Email: valid characters(restrict to email format (something@somewhere.com))
	## Username: valid characters(letters and numbers)
	valid_answers=("$2")
	
	
	if [ "$3" = "Password" ]; then
		read -s -p "$1: "$'\n' question
	else 
		read -p "$1: " question 
	fi
	for ((i = 0; i < ${#valid_answers[@]}; i++))
    do
        if [[ "$question" =~ ^(${valid_answers[$i]})$ ]];
        then 
           	#echo "Valid"
			echo "$question"
        else
			
			#ask "$1" "${valid_answers[@]}"
			if [ "$3" = "Password" ];
			then
				ask "Invalid $3, try again" "$2" "$3"
			else
				ask "Invalid $3, try again" "$2" "$3"
			fi
        fi

    done
	

}
export -f ask

guiText(){
	# Automatic comment format for simple setup as a text based gui
	# eg. guiText "Redis" "Start"
	# $1 Name of object to process
	# $2 Type of process
	case $2 in 
		"Link")
			echo
			echo
			echo "More info regarding $1-webstack installer"
			echo "can be found on https://github.com/parentnode/$1-environment"
			if [ "$1" = "mac" ];
			then
				echo "and https://parentnode.dk/blog/installing-the-web-stack-on-mac-os"
			fi
			if [ "$1" = "windows" ];
			then
				echo "and https://parentnode.dk/blog/installing-web-stack-on-windows-10"
			fi
			if [ "$3" = "ubuntu-client" ];
			then
				echo "and https://parentnode.dk/blog/installing-the-web-stack-on-ubuntu"
			fi
			if [ "$3" = "ubuntu-server" ];
			then
				echo "and https://parentnode.dk/blog/setup-ubuntu-linux-production-server-and-install-the-parentn"
			fi
			
			echo
			echo
			;;
		"Comment")
			echo
			echo "$1:"
			if [ -n "$3" ];
			then
				echo "$3"
			fi
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
		"Exist")
			echo
			echo "$1 allready exists"
			if [ -n "$3" ];
			then
				echo "checking for $3"
			fi
			echo
			echo
			;;
		"Install")
			echo
			echo "Configuring installation for $1"
			if [ -n "$3" ]; then
				echo "in $3"
			fi
			echo
			;;
		"Replace")
			echo
			echo "Replacing $1 with $3"
			echo
			;;
		"Installed")
			echo
			echo "$1 Installed no need for more action at this point"
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
}
export -f guiText

trimString(){
	trim=$1
	echo "${trim}" | sed -e 's/^[ \t]*//'
}
export -f trimString
checkAlias() 
{
	#dot_profile
	file=$1
	#bash_profile.default
	default=$2
	echo "Updating $file alias"
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
export -f checkAlias
#!/bin/bash -e
updateStatementInFile(){
    	#check_statement=$1
	input_file=$2
	output_file=$3
	read_input_file=$(<"$input_file")
	read_output_file=$( < "$output_file")
	check=$(echo "$read_output_file" | grep -E ^"$1" || echo "")
	if [ -n "$check" ];
	then 
		# deletes existing block of code
		sed -i "/# $1/,/# end $1/d" "$output_file"
		# inserts parentnode newest block of code
		echo "$read_input_file" | sed -n "/# $1/,/# end $1/p" >> "$output_file"
	fi
	echo ""	
}
export -f updateStatementInFile

# Updates all the sections in the .bash_profile file with files in parentnode dot_profile
copyParentNodePromptToFile(){
	#updateStatementInFile "admin check" "/mnt/c/srv/tools/conf/dot_profile" "$HOME/.bash_profile"
	updateStatementInFile "running bash" "/mnt/c/srv/tools/conf/dot_profile" "$HOME/.bash_profile"
	updateStatementInFile "set path" "/mnt/c/srv/tools/conf/dot_profile" "$HOME/.bash_profile"
	## Updates the git_prompt function found in .bash_profile 
	# simpler version instead of copyParentNodeGitPromptToFile. awaiting approval 
	updateStatementInFile "enable git prompt" "/mnt/c/srv/tools/conf/dot_profile_git_promt" "$HOME/.bash_profile"
	
}
export -f copyParentNodePromptToFile

# Checks string content
checkStringInFile(){
	search_string=$(grep -E "$1" $2 || echo "")
	if [ -z "$search_string" ]; 
	then
		echo "Not Found"
	else
		echo "Found"
	fi

}
export -f checkStringInFile

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
gitConfigured(){
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
export -f gitConfigured

installedPackage(){
	installed_package=$(dpkg --get-selections | grep $1 || echo "")
	if [ -z "$installed_package" ];
	then
		guiText "$1" "Install"
		sudo apt install -y $1
		if [ "$1" == "ffmpeg" ]; then
			sudo -$2 apt install $1 -y
		fi
		if [ "$1" == "mariadb-server" ]; then
			sudo -$2 apt install -$3 $1 -y
		fi
	else 
		guiText "$1" "Installed"
	fi
}
export -f installedPackage
