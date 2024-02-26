#!/bin/bash


# First step to create a function of clonning

code_clone(){
	read -p "Enter the path here :" path
	echo "Clonning the app from GitHub...."
	# Extract the path from URL
	code_path=$(echo "$path" | sed -n 's#.*/\([^/]*\.git\)#\1#p')
	echo $code_path
	# Remove the ".git" extention
       	directory=$(echo "$code_path" | sed 's/\.git$//')
	echo $directory

	if [[ ! -d "/mnt/c/Users/priya/Desktop/basic_project/deploy_app_with_linux/$dircctory" ]]

       	then
		git clone $path || {
		echo "$directory"
		echo "Failed to clone the code."
		return 1
	}
	else
		echo "The code directory already exists. Skipping clone."
                 # Change to the code directory
                echo "Directory is exist, change the directory"
                cd "/mnt/c/Users/priya/Desktop/basic_project/deploy_app_with_linux/$directory"
	       	echo "Changing directory is done" || {
                echo "Failed to change to the code directory."
                echo "Directory changed"
                return 1
	}
	fi
}

# Function to install required dependencies
install_requirements() {
    	echo "Installing dependencies..."
	# Update package information
    	sudo apt-get update || {
        echo "Failed to update package information."
        return 1
    	}
    	
	sudo apt-get install -y docker.io nginx docker-compose python3-django || {
        echo "Failed to install dependencies."
        return 1
    	}
}

# Function to perform required restarts
required_restarts() {
    	echo "Performing required restarts..."
    	sudo chown "$USER" /var/run/docker.sock || {
        echo "Failed to change ownership of docker.sock."
        return 1

	sudo systemctl enable docker
	sudo systemctl enable nginx
    }
}
# Function to deploy the Django app
deploy() {
    	echo "Building and deploying the Django app..."
    	docker build -t todo-app . && docker run  -d -p  8000:8000 todo-app || {
        echo "Failed to build and deploy the app."
        return 1
    }
}


# Main deployment script
echo "********** DEPLOYMENT STARTED *********"

# Clone the code
code_clone


# Install dependencies
if ! install_requirements 
then
    exit 1
fi

# Perform required restarts
if ! required_restarts
then
    exit 1
fi

# Deploy the app
if ! deploy 
then
    echo "Deployment failed. Mailing the admin..."
    # Add your sendmail or notification logic here
    exit 1
fi

echo "********** DEPLOYMENT DONE *********"


