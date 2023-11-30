#!/bin/sh

echo "Complementary package installation: MOJTABA BAHRAMGIRI @ APSRC Jun-27-2022"
echo "Package installation for ROS1 MELODIC using apt"

NC='\033[0m'       # Text Reset
R='\033[0;31m'          # Red
G='\033[0;32m'        # Green
Y='\033[0;33m'       # Yellow
B='\033[0;34m'         # Blue
P='\033[0;35m'       # Purple
C='\033[0;36m'         # Cyan
W='\033[0;37m'        # White

default_list="./install.log"
check_list=${1:-$default_list}
if [ ! -f $check_list ]; then echo "No list has selected"; exit 1; fi

while IFS= read -r line; do
 temp=$(echo ros-$ROS_DISTRO-$line | tr '_' '-')
 eval sudo apt install $temp
 if [ $? -eq "0" ]; then
  echo "${line}: ${G}Installed successfully${NC}"
  echo "Check for rosversion ${line} ..."
  eval rosversion $line
 else
   echo "${line}: ${R}Failed to install${NC}"
   echo $line >> install.log1
 fi
done < $check_list

echo "${Y}Check install.log for missing packages${NC}"
mv install.log1 install.log
