#!/usr/bin/env bash

CRON_DIR="/srv/crons"
EXPIRE_DAYS=90


if [ ! -d "$CRON_DIR" ]; then
	echo "Directory not found: $CRON_DIR" >&2
	exit 1
fi


# List files older than DAYS in $DIR
echo "Cron output files in $CRON_DIR older than $EXPIRE_DAYS days:"
find "$CRON_DIR" -type f -mtime +"$EXPIRE_DAYS" -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' | sort


# Delete safely (handles filenames with whitespace/newlines)
#echo "Delete cron output files in $CRON_DIR older than $EXPIRE_DAYS days:"
#find "$CRON_DIR" -type f -mtime +"$DAYS" -print0 | xargs -0 --no-run-if-empty rm -v --

