#!/bin/bash
bold=$(tput bold)
yell=${bold}$(tput setaf 1)
info=${bold}$(tput setaf 2)
warn=${bold}$(tput setaf 3)
normal=$(tput sgr0)
echo "This Script Should Be Run In The ${warn}Root User's Home Folder${normal} And Will Require An ${warn}Internet Connection.${normal}"
echo "Press \"y/Y\" To Confirm..."
read option
if [ $option == "y" ] || [ $option == "Y" ]; then
    echo "Continuing Install..."
    echo "Adding Log and Configuration Locations.."
    mkdir logs
    mkdir conf
    echo "Installing Dependencies..."
    echo "${info}git${normal}: For FTA Script Update Management."
    yum install -q -y git
    echo "${info}sshpass${normal}: For Command Line SFTP Login."
    yum install -q -y sshpass 
    echo "${info}ssmtp${normal}: For Email Notifications."
    yum install -q -y ssmtp
    echo "${info}unzip${normal}: For Archive Handling." 
    yum install -q -y unzip
    echo "Collecting FTA Script And Documentation."
    git clone -q https://github.com/James-Ingram/File-Transfer.git
    cp -R File-Transfer/* .
    rm -rf File-Transfer
    echo "${yell}Deleting${normal} This Copy Of The Setup Script Another Copy Is In: ${info}./info/initial-setup.sh${normal}"
    rm -rf $0
else
    echo "Cancelled FTA Setup.."
fi