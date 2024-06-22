#!/bin/bash

set -euo pipefail

check_awscli() {
    	if ! command -v aws &> /dev/null; then
        	echo "AWS CLI is not installed. Please install it first." >&2
		return 1
    	fi
}

install_awscli() {
    	echo "Installing AWS CLI v2 on Linux..."

    	# Download and install AWS CLI v2
    	curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    	sudo apt-get install -y unzip &> /dev/null
    	unzip -q awscliv2.zip
    	sudo ./aws/install

    	# Verify installation
    	aws --version

    	# Clean up
    	rm -rf awscliv2.zip ./aws
}

create_s3(){
	local bucket_name="$1"
    	local region="$2"
	# AWS CLI command to create an S3 bucket and capture the bucket ID
	bucket_id=$(aws s3api create-bucket --bucket "$bucket_name" --region "$region" --create-bucket-configuration LocationConstraint="$region" --query 'Bucket')
	# Check if the bucket creation was successful
	if [ $? -eq 0 ]; then
    		echo "S3 bucket created successfully with ID: $bucket_id"
	else
    		echo "Failed to create S3 bucket."
	fi


	iam_user_name="$3"
        policy_name="s3-get-object--policy"

	# Create an IAM policy allowing GetObject permission on the bucket
        policy_arn=$(aws iam create-policy \
  --policy-name "$policy_name" \
  --policy-document '{
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": "s3:GetObject",
              "Resource": "arn:aws:s3:::'"$bucket_name"'/*"
          }
      ]
  }' \
  --output text \
  --query 'Policy.Arn')

	 # Attach the policy to the IAM user
        aws iam attach-user-policy \
        --user-name "$iam_user_name" \
        --policy-arn "$policy_arn"

	# Detach the policy from the IAM user
        aws iam detach-user-policy \
        --user-name "$iam_user_name" \
        --policy-arn "$policy_arn"


	# Upload a file to the iS3 bucket
	
	echo "Uploading a file....."

        local file_to_upload="$4"
        aws s3 cp $file_to_upload s3://$bucket_name


	# Check if the file upload was successful
        if [ $? -eq 0 ]; then
                echo "File uploaded successfully to S3 bucket."
        else
                echo "Failed to upload file to S3 bucket."
        fi
	
	# Delete the IAM policy
	aws iam delete-policy \
  	--policy-arn "$policy_arn"

}


main(){

	if ! check_awscli ; then
	install_awscli || exit 1
	fi


	echo "Creating a S3 bucket......"

	BUCKET_NAME="priyanshu-3006"
	REGION_NAME="us-west-1"
		
	# Call the function to create the S3 bucket
	read -p "Enter the IAM user name:" IAM_USER
	read -p "Enter the path :" FILE_TO_UPLOAD

	create_s3 "$BUCKET_NAME" "$REGION_NAME" "$IAM_USER" "$FILE_TO_UPLOAD"
	

	echo "S3 bucket creation completed."
}

main "$@"

