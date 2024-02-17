#!/bin/bash

# Monitoring free RAM space 
monitor=$(free -mt | grep "Total" | awk '{print $4}')


if [[ $monitor -le 2000 ]]
then
	echo "You have not enough space to process further"
else
	echo "You have enough space to process further"
fi
