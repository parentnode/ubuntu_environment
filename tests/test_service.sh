 outputHandler "section" "Install software"
	outputHandler "comment" "Installing Apache and extra modules"
    #sudo apt install -y apache2 apache2-utils ssl-cert
	apache_service=$(testCommand "service apache2 status) 2> /dev/nul" 
	valid_status=("running" "dead")
	#echo "Checking Apache2.4 status: "
	apache_running=$(testCommand "service apache2 status" "${valid_status[@]}" || echo "")
	if [ -z "$apache_running" ]; then
		command "sudo apt-get install -y apache2 apache2-utils ssl-cert"
	else
		outputHandler "comment" "Apache Installed" "[Apache status:] $(testCommand "service apache2 status" "${valid_status[@]}")"
	fi