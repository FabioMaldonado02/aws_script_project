#!bin/bash

#Color Varables (Colors that is used in AWS)
BLUE='\033[0;34m'
GOLD='\033[0;33m'
NC='\033[0m' # No Color

#Helps identify the instance
uid=$RANDOM
tag="<tag_name>"

#Commands (I will be using and addin more into my final draft)
#aws ec2 run-instances
#aws ec2 terminate-instances --instance-ids #IMAGEID
#ssh -i key_name kali@machine_ip

#Inchangeable Varables
#For Github I will be adding placeholders
user_ami="<ami_placeholder>"
user_instances_type="<type_placeholders>"
user_key_name="<key_name_placeholder>"
user_security_group_ids="<group_placeholder>"
user_region="us-west-1"

# Changeable Varables
# I won't be decaring them here
# aws_access_key_id = user_aws_access_key
# aws_secret_access_key=user_aws_secret_access_key
# aws_session_token=user_aws_session_token
# --instance-ids #IMAGEID
# kali@ #THE IP CHANGES

#My opening art to my project
echo -e $GOLD"\
  _   _   _     _   _   _   _     _   _   _   _   _   _   _  
 / \ / \ / \   / \ / \ / \ / \   / \ / \ / \ / \ / \ / \ / \ 
( A | W | S ) ( M | e | n | u ) ( P | r | o | j | e | c | t )
 \_/ \_/ \_/   \_/ \_/ \_/ \_/   \_/ \_/ \_/ \_/ \_/ \_/ \_/ "$NC

# Menu

while true; do
  # Present menu options to the user

  echo -e $BLUE"1. Start an EC2 Instance"
  echo "2. SSH into EC2 Instance"
  echo "3. Add Pentesting tools to Kali"
  echo "4. Terminate EC2 instances"
  echo "5. Exit"

  # Get user selection
  read -p "Enter your selection: " selection

  # Validate user input
  if [[ ! "$selection" =~ ^[0-5]$ ]]; then
    echo "Invalid selection. Please try again."
    continue
  fi

  # Process user selection
  case $selection in
  1)
    # Start instance for EC2
    # Prompt the user for their AWS access key ID
    read -p "Enter your AWS access key ID: " user_aws_access_key

    # Prompt the user for their AWS secret access key
    read -sp "Enter your AWS secret access key: " user_aws_secret_access_key
    echo ""

    #Prompt the user for their session token
    read -sp "Enter your AWS session token:  " user_aws_session_token
    # Store the credentials in a configuration file
    cat >~/.aws/credentials <<EOL
      [default]
      aws_access_key_id = $user_aws_access_key
      aws_secret_access_key = $user_aws_secret_access_key
      aws_session_token = $user_aws_session_token

EOL
    #A message to the user there credentials are saved and to wait a little till the instance is ready.
    echo "AWS credentials saved successfully."
    echo "Wait a couple of seconds"
    #Usng the varables to start up a instance
    aws ec2 run-instances --image-id $user_ami --count 1 --instance-type $user_instances_type --key-name $user_key_name --security-group-ids $user_security_group_ids --region $user_region --associate-public-ip-address --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":30,"DeleteOnTermination":true}}]' --tag-specifications "ResourceType=instance,Tags=[{Key=WatchTower,Value='$tag'},{Key=AutomatedID,Value='$uid'}]" | grep InstanceId | cut -d":" -f2 | cut -d'"' -f2
    aws_account_ID=($(aws sts get-caller-identity --query 'Account' --output text))
    echo "Your Account AWS ID: $aws_account_ID will be used for this script"
    #ec2_id is put into a varable to get the instance id.
    ec2_id=$(aws ec2 describe-instances --filters "Name=tag:AutomatedID,Values=$uid" "Name=tag:WatchTower,Values=$tag" --query 'Reservations[].Instances[].InstanceId' --output text)
    #ec2_id is put in the loop so it will get the id once it pop up. 
    while [ -z "$ec2_id" ]; do
      echo "Waiting for EC2 ID"
      ec2_id=$(aws ec2 describe-instances --filters "Name=tag:AutomatedID,Values=$uid" "Name=tag:WatchTower,Values=$tag" --query 'Reservations[].Instances[].InstanceId' --output text)
      sleep 1
    done
    echo "$ec2_id"
   
    ;;

  2)
    aws_machine_ip=$(aws ec2 describe-instances --instance-ids $ec2_id --query 'Reservations[0].Instances[0].PublicIpAddress' | cut -d'"' -f2)
    echo "$aws_machine_ip"
    #SSH into EC2 Instance"
    #This will ssh into the machine
    #So, it will be easy to automate by entering 2
    ssh -i <file_address_key> kali@$aws_machine_ip

    ;;
  3)
    aws_machine_ip=$(aws ec2 describe-instances --instance-ids $ec2_id --query 'Reservations[0].Instances[0].PublicIpAddress' | cut -d'"' -f2)
    #Add pentesting tools to your kali
    echo "Adding pentest tools to kali"
    sudo ssh -o "StrictHostKeyChecking no" -t -i <file_address_key> kali@$aws_machine_ip 'bash -s' <tools_setup.sh

    ;;
  4)
    #Terminate EC2 instances
    aws ec2 terminate-instances --instance-ids $ec2_id

    ;;
  5)
    # Exit the program
    exit
    ;;
  esac
done
$BLUE
