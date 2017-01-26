# Usage
# crontab: 45 3 * * * /srv/tools/_tools/dataprotectionplan.sh #DB# #DB-USER# #DB-PASS# #RECIPIENT1[,RECIPIENT2]#


echo "DATAPROTECTIONPLAN FOR $1"
echo "- dump database"
echo "- make zipped tarball"
echo "- encrypt data"
echo "- send as email"

mysqldump -u $2 -p$3 $1 > $1.sql

tar -czvf $1.sql.tar.gz $1.sql

openssl aes-128-cbc -k $3 < $1.sql.tar.gz > $1.sql.tar.gz.aes

# decryption done by
# openssl aes-128-cbc -d < yourfile.txt.aes > yourfile.txt

echo "You are welcome :)" | mail -s "DATA PROTECTION PLAN FOR $1" -A $1.sql.tar.gz.aes $4


# clean up
rm $1.sql
rm $1.sql.tar.gz
rm $1.sql.tar.gz.aes

echo
echo "Data is sent - clean up is done"

