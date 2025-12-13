#!/usr/bin/env bash


# Crontab
# 0 0 * * * mkdir -p /srv/crons/gdpr-log-cleaner && /srv/tools/scripts/cron/gdpr_log_cleaner.sh >> /srv/crons/gdpr-log-cleaner/gdpr-log-$(date +\%Y-\%m-\%d_\%H\%M\%S).log 2>&1


SITES_DIR="/srv/sites"
LOG_DIR="*/theme/library/log"
#EXPIRE_DAYS=180
EXPIRE_DAYS=3300
OUTPUT_DIR="/srv/crons/gdpr-log-cleaner"


# Check if SITES_DIR exists
if [ ! -d "$SITES_DIR" ]; then
	echo "Directory not found: $SITES_DIR" >&2
	exit 1
fi


# Ensure output directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
	mkdir -p "$OUTPUT_DIR"
fi


# Find log files located in /srv/sites/*/theme/library/log (and list them if older than EXPIRE_DAYS)
# echo "Janitor log files in $SITES_DIR/$LOG_DIR older than $EXPIRE_DAYS days:"
# find "$SITES_DIR" -type f -path "$LOG_DIR/*" -mtime +"$EXPIRE_DAYS" -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' | sort

# Once old log files have been expired, new log files will contain .log extension
# find "$SITES_DIR" -type f -path "$LOG_DIR/*.log" -mtime +"$EXPIRE_DAYS" -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' | sort

# Delete
echo "Delete Janitor log files in $SITES_DIR/$LOG_DIR older than $EXPIRE_DAYS days:"
find "$SITES_DIR" -type f -path "$LOG_DIR/*" -mtime +"$EXPIRE_DAYS" -print0 | xargs -0 --no-run-if-empty rm -v --

