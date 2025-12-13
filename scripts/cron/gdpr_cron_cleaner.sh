#!/usr/bin/env bash


# Crontab
# 0 0 * * 1 /srv/tools/scripts/cron/gdpr_cron_cleaner.sh >> /srv/crons/gdpr-cron-cleaner/gdpr-cron-$(date +\%Y-\%m-\%d_\%H\%M\%S).log 2>&1


CRON_DIR="/srv/crons"
EXPIRE_DAYS=90
OUTPUT_DIR="/srv/crons/gdpr-cron-cleaner"


# Check if CRON_DIR exists
if [ ! -d "$CRON_DIR" ]; then
	echo "Directory not found: $CRON_DIR" >&2
	exit 1
fi


# Ensure output directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
	mkdir -p "$OUTPUT_DIR"
fi


# List files older than DAYS in $DIR
echo "Cron output files in $CRON_DIR older than $EXPIRE_DAYS days:"
find "$CRON_DIR" -type f -mtime +"$EXPIRE_DAYS" -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' | sort


# Delete safely (handles filenames with whitespace/newlines)
#echo "Delete cron output files in $CRON_DIR older than $EXPIRE_DAYS days:"
#find "$CRON_DIR" -type f -mtime +"$DAYS" -print0 | xargs -0 --no-run-if-empty rm -v --

