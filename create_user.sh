#!/bin/bash

# Check if the user in root or not for creation
if [[ "${UID}" -ne 0 ]]
then
	echo "Please run with sudo or root"
	exit 1
fi

# User should provide atleast one argument as username 

if [[ "${#}" -lt 1 ]]
then
	echo "Usage: ${0} username comment...."
	echo "Create a user with name USER_NAME and comment field of comment"
	exit 1
fi

# Store first argument as username

user_name=${1}

# In case of one or more argument, it store as comment
shift
comment="${@}"

# Create passward
read -s -p "Enter the new password for $user_name: " password

# For demonstration purposes, let's just display asterisks instead of the actual password
masked_password=$(echo "$password" | sed 's/./\*/g')

# Create user
useradd -c "${comment}" -m $user_name

# Check if user is succesfully created or not

if [[ $? -ne 0 ]]
then
	echo "The account could not be created"
	exit 1
fi

# Set password

echo "$user_name:$password" | sudo chpasswd

# Check if the password is successfully set or not

if [[ $? -ne 0 ]]
then
        echo "Password could not be set"
        exit 1
fi

# Forced password change on first login

passwd -e $user_name

# Display the username, password and host where the user was created

echo "----------------------"
echo "Username: $user_name"
echo "----------------------"
echo "Comment: $comment"
echo "----------------------"
echo "Password: $masked_password"
echo "----------------------"
echo $(hostname)
echo "----------------------"

# List down the number of users 
read -p "Enter this(Yes/yes) if you want to list the users" user

if [[ user == 'Yes' || user == 'yes' ]]
then
	echo awk -F: '{ print $1}' /etc/passwd
else
	echo "Thanks for creating a user"
fi



