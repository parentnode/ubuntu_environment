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
		"comment")
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
		"section")
			echo
			echo 
			echo "{---$2---}"	
			echo
			echo
			;;
		"exit")
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
	## Choice yes and no: Y/n
	valid_answers=("$2")
	
	
	if [ "$3" = "password" ]; then
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
			if [ "$3" = "password" ];
			then
				ask "Invalid $3, try again" "$2" "$3"
			else
				ask "Invalid $3, try again" "$2" "$3"
			fi
        fi

    done
	

}
export -f ask

# Check if program/service are installed
testCommand(){
# Usage: returns a true if a program or service are located in 
# P1: kommando
# P2: array of valid responses
	valid_response=("$@")
	for ((i = 0; i < ${#valid_response[@]}; i++))
	do
		command_to_test=$($1 | grep -E "${valid_response[$i]}" || echo "")
		if [ -n "$command_to_test" ]; then
			echo "$command_to_test" 
		fi
	done

}
export -f testCommand

checkGitCredential(){
	value=$(git config user.$1)
	echo "$value"

}
export -f checkGitCredential

checkMariadbPassword(){
	# When the service are installed it can either be running or dead
	# If there is output of this command if it is active or not active then mariadb service is installed
	mariadb_installed=$(service mariadb status || echo "")
	#echo "Mariadb installed:  $mariadb_installed"
	if [ -n "$mariadb_installed" ]; then
		valid_status=("dead" "running")
		mariadb_running=$(testCommand "service mariadb status" "${valid_status[@]}" || echo "")
		#echo "Mariadb Running: $mariadb_running"
		# if service is running
		if [ -n "$(echo $mariadb_running | grep -o running)" ]; then
			# check if we can login without password and do stuff return a line confirming if there are a password or an empty string
			has_password=$(mysql -u root -E STATUS 2>&1 >/dev/null | grep "using password: NO" || echo "")
			#echo "Has password: $has_password"
			# if the line "using password: NO" is a result 
			if [ -n "$has_password" ]; then
				# password is set
				password_is_set="true"
				echo "$password_is_set"
			fi
		#if service is not running
		else
			echo "mariadb service not running"
			# start service
			echo "Starting mariadb service $(sudo service mariadb start)"
			#running the function again
			checkMariadbPassword
		fi
	# return wether or not mariadb password exists
	else
		password_is_set="false"
		echo "$password_is_set"
	fi
}
export -f checkMariadbPassword


# Copy file from source to destination
copyFile(){
	# $1 is source file you want to copy
	# $2 destination where you want to copy to
	cp $1 $2
}
export -f copyFile

#Check if a file exists
fileExists(){
	#$1 file to check for
	if [ -f $1 ]; then
		echo "true"
	else
		echo "false"
	fi
}
export -f fileExists

# Check if source file have parentnode file content
checkFileContent(){
	query=$1
	source=$(<$2)
	check_query=$(echo "$source" | grep "$query" || echo "")
	if [ -n "$check_query" ]; then
		echo "true"
	fi 
}
export -f checkFileContent

syncronizeAlias(){
    
	# Uncomment this source and destination when testing, comment out when done
	#source=$(</srv/sites/parentnode/ubuntu_environment/tests/test_syncronize_alias/source)
	#destination=/srv/sites/parentnode/ubuntu_environment/tests/test_syncronize_alias/destination
	
	# Comment out this source and destination when testing, uncomment when done
	source=$(</srv/tools/conf-client/default_conf_alias)
	destination=$HOME/.bash_profile

	readarray -t source_key <<< $(echo "$source" | grep "alias" | cut -d \" -f2) 
    readarray -t source_value <<< $(echo "$source" | grep "alias" | cut -d \" -f3,4,5) 
    
    for i in "${!source_key[@]}"
    do
        sed -i 's%'"${source_key[$i]}.*"'%'"$(trimString "${source_value[$i]}")"'%g' $destination
        
    done
}
export -f syncronizeAlias

updateContent(){
    sed -i "/$1/,/$1/d" "$3" 
    readdata=$( < $2)
    echo "$readdata" | sed -n "/$1/,/$1/p" >> "$3"
}
export -f updateContent

# Check folder exists create if not
checkFolderExistOrCreate(){
    if [ ! -e "$1" ]; then
        echo "Creating folder $1"
        mkdir "$1" 
    else 
        echo "Folder allready exists"
    fi
}
export -f checkFolderExistOrCreate

command(){
    if [[ $2 == true ]]; then
        cmd=$($1 1> /dev/null)
    else
        cmd=$($1)
    fi
    echo "$cmd"
}
export -f command

trimString(){
	trim=$1
	echo "${trim}" | sed -e 's/^[ \t]*//'
}
export -f trimString
