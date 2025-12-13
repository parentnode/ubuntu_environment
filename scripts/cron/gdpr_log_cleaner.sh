#!/usr/bin/env bash

SITES_DIR="/srv/sites"
LOG_DIR="*/theme/library/log"
EXPIRE_DAYS=180


if [ ! -d "$SITES_DIR" ]; then
	echo "Directory not found: $SITES_DIR" >&2
	exit 1
fi


# Find log files located in /srv/sites/*/theme/library/log (and list them if older than EXPIRE_DAYS)
echo "Janitor log files in $SITES_DIR/$LOG_DIR older than $EXPIRE_DAYS days:"
find "$SITES_DIR" -type f -path "$LOG_DIR/*" -mtime +"$EXPIRE_DAYS" -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' | sort

# Once old log files have been expired, new log files will contain .log extension
# find "$SITES_DIR" -type f -path "$LOG_DIR/*.log" -mtime +"$EXPIRE_DAYS" -printf '%TY-%Tm-%Td %TH:%TM:%TS %p\n' | sort

# Delete
#echo "Delete Janitor log files in $SITES_DIR/$LOG_DIR older than $EXPIRE_DAYS days:"
# find "$SITES_DIR" -type f -path "$LOG_DIR/*" -mtime +"$EXPIRE_DAYS" -print0 | xargs -0 --no-run-if-empty rm -v --
