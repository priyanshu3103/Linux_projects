#!/bin/bash


# Monitoring free DISK space and send at e-mail


monitor=$(df -h | egrep -v "Filesystem|snapfuse|tmpfs" | grep "drvfs" | grep "/mnt/c" | awk '{print $5}' | tr -d %)

let "calcu = 100-$monitor" 
if [[ $monitor -ge 80 ]]
then
	echo "Your DISK space is full"
else
	echo "Your DISK space is still $calcu% remaining"
	echo "Current space: $monitor%"
fi
