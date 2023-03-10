#!/bin/bash
clear
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
sudo apt-get update && sudo apt-get full-upgrade -y -q

sudo apt-get install -y -q kali-tools-web >kali_webtools.log 2>&1
if [ $? -ne 0 ]; then
    echo "Aws Cli failed, check Aws_cli.log for more information"
else
    echo "Kali Web Tools installation succeeded"
fi

sudo apt-get install -y awscli >apt_install.log 2>&1
if [ $? -ne 0 ]; then
    echo "Aws Cli installation failed, check apt_install.log for more information"
else
    echo "Aws Cli installation succeeded"
fi

#install pip
sudo apt install -y -q python3-pip >python3_pip.log 2>&1
if [ $? -ne 0 ]; then
    echo "Pip install failed, check python3_pip.log for more information"
else
    echo "Pip installation succeeded"
fi

#make a testing tool folder
mkdir /home/kali/testing_tools
cd /home/kali/testing_tools

#make sure nmap is installed.
sudo apt install -y -q nmap >nmap.log 2>&1
if [ $? -ne 0 ]; then
    echo "Nmap install failed, check nmap.log for more information"
else
    echo "Nmap installation succeeded"
fi

# get rust scan
wget https://github.com/RustScan/RustScan/releases/download/1.10.0/rustscan_1.10.0_amd64.deb
chmod +x rustscan_1.10.0_amd64.deb
sudo dpkg -i rustscan_1.10.0_amd64.deb >rustscan_install.log 2>&1
if [ $? -ne 0 ]; then
    echo "rustscan install failed, check rustscan_install.log for more information"
else
    echo "Rustscan installation succeeded"
fi

#git clone payloadallthethings
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git

#cloudEnum
git clone https://github.com/initstring/cloud_enum.git
cd /home/kali/testing_tools/cloud_enum
pip install -r ./requirements.txt >cloud_enum_install.log 2>&1
if [ $? -ne 0 ]; then
    echo "cloudEnum install failed, check cloud_enum_install.log for more information"
else
    echo "Cloud Enum installation succeeded"
fi

echo "The pentesting tool install is done"
