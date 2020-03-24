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
	if [ "${site_array[0]}" != "${site_array[1]}" ]; then 
		for ((doc_root = 0; doc_root < ${#document_root[@]}; doc_root++))
        do
            echo "${document_root[doc_root]}"
        done
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
	echo "$(getSiteInfo "${document_root[@]}")"
	# Parse ServerName from httpd-vhosts.conf
	#server_name=$(grep -E "ServerName" "$PWD/apache/httpd-vhosts.conf" | sed "s/	ServerName //")
	server_name=($(grep -E "ServerName" "$PWD/apache/httpd-vhosts.conf" | sed "s/	ServerName //"))
	echo "$(getSiteInfo "${server_name[@]}")"
	# Parse ServerAlias from httpd-vhosts.conf
	server_alias=($(grep -E "ServerAlias" "$PWD/apache/httpd-vhosts.conf" | sed "s/	ServerAlias //"))
    echo "$(getSiteInfo "${server_alias[@]}")"
#    if [ "${document_root[0]}" = "${document_root[1]}" ]; then 
#        doc_root=$(echo "${document_root[0]}")
#        export doc_root
#    else
#        for ((doc_root = 0; doc_root < ${#document_root[@]}; doc_root++))
#        do
#            echo "${document_root[doc_root]}"
#        done
#    fi
#    if [ "${server_alias[0]}" = "${server_alias[1]}" ]; then
#        serv_alias=$(echo "${server_alias[0]}")
#        export serv_alias
#    else
#        for ((s_alias = 0; s_alias < ${#server_alias[@]}; s_alias++))
#        do
#            echo "${server_alias[s_alias]}"
#        done
#    fi
#    
#    if [ "${server_name[0]}" = "${server_name[1]}" ]; then
#    
#    else
#        for ((sname = 0; sname < ${#server_name[@]}; sname++))
#        do
#            echo "${server_name[sname]}"
#        done
#    fi
    
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