#!/bin/bash

# Set the variables
backup_destination="/mnt/p/basic_project/Files_backup/backup_destination"
log_files="/mnt/p/basic_project/Files_backup/logs/backup.log"
source_directory="/mnt/p/basic_project/Files_backup/backup"
DATE=$(date +"%Y:%m:%d %H:%M:%S")

#Function to log message

log_message() {
	local log_level=$1
	local message=$2
	echo "$(date +"%Y-%m-%d %H:%M:%S") [$log_level] - $message" >> "$log_files"

}

# Function to perform backup
perform_backup(){
	log_message "INFO" "Starting backup process....."
	
	rsync -av --exclude="/path/to/exclude" "$source_directory" "$backup_destination"
	
	if [[ $? -eq 0 ]];
	then
		log_message "INFO" "Backup completed successfully."
	else
		log_message "ERROR" "Backup failed. Check the logs for details."
	fi

}

# Main script execution 

log_message "INFO" "--------------------Backup execution - $DATE --------------------"

# Check backup destination is exist or not

if [[ ! -d "backup_destination" ]]
then
	log_message "ERROR" "Backup destination is not exist please create a directory"
	exit 1
fi

# Perform backup
perform_backup

# End the script
log_message "INFO" "--------------------Backup execution is ended -------------------"

