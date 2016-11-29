echo
echo "RACKSPACE TOOLS"

echo
read -p "Install Rackspace Backup Agent - Requires managed account (Y/n): " install_backup_agent
if test "$install_backup_agent" = "Y"; then

	aptitude update
	aptitude install python-apt

	# RACKSPACE BACKUP AGENT
	wget 'http://agentrepo.drivesrvr.com/debian/cloudbackup-updater-latest.deb'

	dpkg -i cloudbackup-updater-latest.deb
	cloudbackup-updater -v

	/usr/local/bin/driveclient --configure
	sudo service driveclient start

else
	echo "Skipping Backup Agent"
fi
