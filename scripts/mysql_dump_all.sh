# Username and Password must be found in /srv/crons/conf/db/root as username|password (no newline)
#
# Remember to set appropriate permissions for cron configs 
# sudo chown -R root:root /srv/crons/conf
# sudo chmod -R 600 /srv/crons/conf



if [ -e "/srv/crons/conf/db/root" ]; then

	# read username and password from conf file
	config=$(cat "/srv/crons/conf/db/root")

	# not working in sh and cronjob runs as sh (not bash)
	# config=$(<"/srv/crons/conf/db/$1")

	# split string
	username=${config%|*}
	password=${config#*|}


	# dump data
	mysqldump -u $username -p$password --all-databases > /srv/database-backup/all-databases-dump.sql


	echo
	echo "Data is exported"

else

	echo "Password file is missing for root"

fi
