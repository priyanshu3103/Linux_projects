#!/bin/bash


# Variables 

base=/mnt/c/Users/priya/Desktop/Devops/scripts/basic/New
days=10
dept=1
run=0


# Check if the directory is present or not

if [ ! -d $base ]
then
	echo "Directory does not exist: $base"
	exit 1
fi

# Create 'Archive' folder if not present

if [ ! -d $base/Archive ]
then
	mkdir $base/Archive
fi

# Find the list of files larger than 20 MB

for i in find $base -maxdepth $depth -type f -size +50KB
do
	if [[ $run -eq 0 ]]
	then 
		echo "[$(date "+%y-%m-%d %H:%M:%S")] archiving $i ==> $base/Archive"
		gzip $i || exit 1
		mv $i.gz $base/Archive || exit 1
	fi
done

	







