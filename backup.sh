#! /bin/bash

#Check to make sure user has entered exactly two arguments
if [ $# -ne 2 ];
then
	echo "Usage: backup.sh  <source directory> <target directory>"
	echo "Please try again"
	exit 1
fi


#check if rsync is installed
if ! command -v rsync > /dev/null 2>&1;
then
    echo "The script requires rsync to be installed"
    echo " Please use your distribution package manager to install it and try again"
    exit 2
fi

# Capture the current date and store it in a format YYYY-MM-DD_HH-MM-SS
current_date=$(date +%Y-%m-%d_%H-%M-%S)

# define the source and target directories
source_dir="$1"
target_dir="$2"


#create and backup folder with a timestamp
backup_dir="$target_dir/backup_$current_date"
mkdir -p "$backup_dir"


#Run rsync to perform the backup
rsync_options ="-av --delete"
rsync $rsync_options "$source_dir/" "$backup_dir/" > "$target_dir/backup_$current_date.log"



#retain only the last 3 backups and delete the older ones
find "$target_dir" -maxdepth 1 -type d -name "backup_*" | sort -r | tail -n +4 | xargs -r rm -rf


echo "Backup completed successfully. Backup folder - $backup_dir"
