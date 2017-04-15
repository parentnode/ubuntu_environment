# Usage
# OLD: crontab: 45 3 * * * /srv/tools/_tools/dataprotectionplan.sh #DB# #DB-USER# #DB-PASS# #RECIPIENT1[,RECIPIENT2]#

# crontab: 45 3 * * * /srv/tools/_tools/dataprotectionplan.sh #DB# #RECIPIENT1[,RECIPIENT2]#

# Username and Password must be found in /srv/crons/conf/db/#DB#

echo "DATAPROTECTIONPLAN FOR $1"
echo "- read username and passwod"
echo "- dump database"
echo "- make zipped tarball"
echo "- encrypt data"
echo "- send as email"

if [ -d "/srv/crons/conf/db/$1" ]; then

	# read username and password from conf file
	config=$(<"/srv/crons/conf/db/$1")

	# split string
	username=${config%|*}
	password=${config#*|}

	mysqldump -u $username -p$password $1 > $1.sql

	tar -czvf $1.sql.tar.gz $1.sql

	openssl aes-128-cbc -k $password < $1.sql.tar.gz > $1.sql.tar.gz.aes

	# decryption done by
	# openssl aes-128-cbc -d < yourfile.txt.aes > yourfile.txt

	echo "You are welcome :)" | mail -s "DATA PROTECTION PLAN FOR $1" -A $1.sql.tar.gz.aes $4


	# clean up
	rm $1.sql
	rm $1.sql.tar.gz
	rm $1.sql.tar.gz.aes

	echo
	echo "Data is sent - clean up is done"

else

	echo "Password file is missing for $1"

fi
