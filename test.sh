#!/bin/bash

# Log into aws
okta_aws success

# Ensure client/node don't exist
knife node list | grep kreedy_terraform_test

if [ $? -eq 0 ]
then
   echo "Node already exists, deleting it"
   knife node delete -y kreedy_terraform_test
fi

knife client list | grep kreedy_terraform_test

if [ $? -eq 0 ]
then
   echo "Client already exists, deleting it"
   knife client delete -y kreedy_terraform_test
fi

# Run terraform and destroy
terraform apply -auto-approve
terraform destroy -auto-approve

# Check That client/node were cleaned up
knife node list | grep kreedy_terraform_test

if [ $? -eq 0 ]
then
   echo "NODE WAS NOT CLEANED UP"
 else
   echo "Node was cleaned up successfully"
fi

knife client list | grep kreedy_terraform_test

if [ $? -eq 0 ]
then
   echo "CLIENT WAS NOT CLEANED UP"
 else
   echo "Client was cleaned up successfully"
fi
