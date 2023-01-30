#!bin/bash

#Color Varables (Colors that is used in AWS)
BLUE='\033[0;34m'
GOLD='\033[0;33m'
NC='\033[0m' # No Color

#Commands (I will be using and addin more into my final draft)
#aws ec2 run-instances
#aws ec2 terminate-instances --instance-ids #IMAGEID 
#ssh -i key_name kali@machine_ip
#Inchangeable Varables 
#For Github I will be adding placeholders
user_ami="ami_image"
user_instances_type="t2.medium"  
user_key_name="key_name" 
user_security_group_ids="Security_group_name"   
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
  echo "3. Terminate EC2 instances"
  echo "4. Exit"
 
  # Get user selection
  read -p "Enter your selection: " selection
  
  # Validate user input
  if [[ ! "$selection" =~ ^[0-4]$ ]]; then
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
      cat > ~/.aws/credentials << EOL
      [default]
      aws_access_key_id = $user_aws_access_key
      aws_secret_access_key = $user_aws_secret_access_key
      aws_session_token = $user_aws_session_token

EOL
      #A message to the user there credentials are saved and to wait a little. 
      echo "AWS credentials saved successfully."
      echo "Wait a couple of seconds"
      #Usng the varables to start up a instance
      aws ec2 run-instances --image-id $user_ami --instance-type $user_instances_type --key-name $user_key_name --security-group-ids $user_security_group_ids --region $user_region
      ;;
    2)
    #SSH into EC2 Instance"
     #Asking the user to provide the machine public ip. 
     read -p "What is the ipv4 of the machine? " aws_machine_ip
     #This will ssh into the machine but I want my final draft to capture the public ip to log in. 
     #So, it will be easy to automate by entering 2
      ssh -i /home/fabian/Downloads/Kail_Fabio.pem kali@$aws_machine_ip
      ;;
    3)
    #Terminate EC2 instances
    #Asking the user to enter the instance id to terminate the machine.
    read -p "To Terminate your instance type your machine Image ID " user_machine_image_id
    #This will use the input to terminate the machine. But I want my final draft to capture the image id
    #And all I'll need is to enter 3. 
    aws ec2 terminate-instances --instance-ids $user_machine_image_id
    ;;  
    4)
      # Exit the program
      exit
      ;;
  esac
done
$BLUE
