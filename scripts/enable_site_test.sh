#!/bin/bash -e

echo "-----------------------------------------------------"
echo ""
echo "                    Enabling site"
echo ""
echo "-----------------------------------------------------"
echo ""


host_file_path="/etc/hosts"

apache_file_path="/srv/sites/apache/apache.conf"
# Request sudo action before continuing to force password prompt (if needed) before script really starts
sudo ls &>/dev/null
echo ""
getSiteInfo(){
	site_array=("$@")
	if [ -n "${site_array[1]}" ]; then
		if [ "${site_array[0]}" = "${site_array[1]}" ]; then 
			echo "${site_array[0]}"
    	else
			echo "${site_array[@]}"
		fi
	else
		echo "${site_array[0]}"
	fi
}
export -f getSiteInfo
# Does current location seem to fullfil requirements (is httpd-vhosts.conf found where it is expected to be found)
if [ -e "$PWD/apache/httpd-vhosts.conf" ] ; then

	# Parse DocumentRoot from httpd-vhosts.conf
	#document_root=$(grep -E "DocumentRoot" "$PWD/apache/httpd-vhosts.conf" | sed -e "s/	DocumentRoot \"//; s/\"//")
	document_root=($(grep -E "DocumentRoot" "$PWD/apache/httpd-vhosts.conf" | sed -e "s/	DocumentRoot \"//; s/\"//"))
	export document_root
	echo "DocumentRoot: $(getSiteInfo "${document_root[@]}")"
	# Parse ServerName from httpd-vhosts.conf
	#server_name=$(grep -E "ServerName" "$PWD/apache/httpd-vhosts.conf" | sed "s/	ServerName //")
	server_name=($(grep -E "ServerName" "$PWD/apache/httpd-vhosts.conf" | sed "s/	ServerName //"))
	export server_name
	#echo "$(getSiteInfo "${server_name[@]}")"
	
	# Parse ServerAlias from httpd-vhosts.conf
	server_alias=($(grep -E "ServerAlias" "$PWD/apache/httpd-vhosts.conf" | sed "s/	ServerAlias //"))
    export server_alias
	echo "$(getSiteInfo "${server_alias[@]}")"

    if [ -z "$(getSiteInfo "${document_root[@]}")" ] && [ -z "$(getSiteInfo "${server_name[@]}")" ]; then
		echo ""
		echo "Apache configuration seems to be broken."
		echo "Please revert any changes you have made to the https-vhosts.conf file."
		echo ""
	else
		echo "Setting up site"
		
		#echo "$(getSiteInfo "${server_alias[@]}")"
		for alias in $(getSiteInfo "${server_alias[@]}")
		do
			echo "$alias"
		done
		for doc in $(getSiteInfo "${document_root[@]}")
		do
			include=$(echo "Include \"$doc | sed s,/theme/www,/apache/httpd-vhosts.conf, )\"")
			apache_entry_exists=$(grep "$include" "$apache_file_path" || echo "")
			echo "$include"
			#echo "Apache Entry: $apache_entry_exists"
			if [ -z "$apache_entry_exists" ]; then
				echo "enabling $include in $apache_file_path"
				#echo "$include" >> "$apache_file_path"
			else
				echo "Virtual Host allready enabled in $apache_file_path"
			fi
		done

		
	fi
	for server in $(getSiteInfo "${server_name[@]}")
	do
		host_exist=$(grep -E 127.0.0.1$'\t'"$site" "$host_file_path" || echo "")
		if [ -z "$host_exist" ]; then 
			sudo chmod 777 "$host_file_path"		
			#echo "Adding hostname to $host_file_path"
			# Add hosts file entry
			echo "127.0.0.1		$server" >> "$host_file_path"
			#echo "127.0.0.1$'\t'"$(getSiteInfo "${server_name[@]}")"" >> "$host_file_path"
			# Set correct hosts file permissions again
			sudo chmod 644 "$host_file_path"
		else 
			echo "$server exists"	
		fi
	done
	
	## Seemingly valid config data
	#if [ ! -z "${document_root[0]}" ] && [ ! -z "${server_name[0]}" ]; then
#
	#	# Show collected data
	#	echo "DocumentRoot:	${document_root[0]}"
	#	echo ""
	#	echo "ServerName: 	${server_name[0]}"
#
	#	# ServerAlias not always present - only print if it is there
	#	if [ ! -z "$server_alias" ]; then
	#		echo "ServerAlias:	$server_alias"
	#	fi
#
	#	echo ""
#
#
	#	# Updating apache.conf
	#	for ((i = 0; i < ${#document_root[@]}; i++))
	#	do
	#		# Get proper projects path (/srv/sites instead of /Users/username/Sites)
	#		parentnode_project_path=$(echo "${document_root[i]}" | sed -e "s/\\/src\\/www//; s/\\/theme\\/www//")
#
	#		# Don't enable sites which are already enabled
	#		# Check if include path already exists in apache.conf
	#		apache_entry_exists=$(grep -E "^Include [\"]?$parentnode_project_path\/apache\/httpd-vhosts.conf[\"]?" "$apache_file_path" || echo "")
	#		if [ -z "$apache_entry_exists" ]; then
#
	#			echo "Adding $parentnode_project_path/apache/httpd-vhosts.conf to apache.conf"
#
	#			# Include project cont in apache.conf
	#			echo ""	>> "$apache_file_path"
	#			#echo "Include \"$parentnode_project_path/apache/httpd-vhosts.conf\"" >> "$apache_file_path"
	#			echo "Include \"$parentnode_project_path/apache/httpd-vhosts.conf\"" >> "$apache_file_path"
#
#
	#		# project already exists in apache.conf
	#		else
#
	#			echo "Project already enabled in $apache_file_path"
#
	#		fi
	#	done
#
#
	#	# Updating hosts
#
	#	# Check hosts configuration
	#	for ((i = 0; i < ${#server_name[@]}; i++))
	#	do
#
	#		hosts_entry_exists=$(grep -E 127.0.0.1$'\t'${server_name[$i]} "$host_file_path" || echo "")
	#		if [ -z "$hosts_entry_exists" ]; then
#
	#			echo ""
	#			echo "Adding ${server_name[$i]} to $host_file_path"
#
	#			# Make hosts file writable
	#			sudo chmod 777 "$host_file_path"
	#				echo "Adding ${server_name[$i]} to $host_file_path"
	#				# Add hosts file entry
	#				echo "" >> "$host_file_path"
	#				echo "" >> "$host_file_path"
	#				echo "127.0.0.1	${server_name[$i]}" >> "$host_file_path"
	#			# Set correct hosts file permissions again
	#			sudo chmod 644 "$host_file_path"
#
	#			echo ""
#
#
	#		# Hosts entry already exists for current domain
	#		else
#
	#			echo "Project already enabled in $host_file_path"
#
	#		fi
	#	done
	#	# Restart apache after modification
	#	echo ""
	#	echo "Restarting Apache"
	#	sudo service apache2 restart
#
#
	#	echo ""
	#	echo "Site enabled: OK"
	#	echo ""
#
#
	## Could not find DocumentRoot or ServerName
	#else
#
	#	echo ""
	#	echo "Apache configuration seems to be broken."
	#	echo "Please revert any changes you have made to the https-vhosts.conf file."
	#	echo ""
#
	#fi

# Could not find httpd-vhosts.conf
else

	echo "Apache configuration not found."
	echo "You can only enable a site, if you run this command from the project root folder"

fi