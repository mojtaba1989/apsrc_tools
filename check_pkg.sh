#!/bin/bash

NC='\033[0m'       # Text Reset
R='\033[0;31m'          # Red
G='\033[0;32m'        # Green
Y='\033[0;33m'       # Yellow
B='\033[0;34m'         # Blue
P='\033[0;35m'       # Purple
C='\033[0;36m'         # Cyan
W='\033[0;37m'        # White

Help()
{
   # Display Help
   echo "Complementary ROS Package version control: MOJTABA BAHRAMGIRI APSRC Jun-27-2022"
   echo
   echo "Syntax: scriptTemplate [-i|x|h]"
   echo "options:"
   echo "-i     Get input list of packages. Not declaired: to_install.log"
   echo "-h     help."
   echo "-x     installed.x file extention"
   echo
}

checklist="./to_install.log"
extension="dummy"

while getopts "hi:x:" opt; do
    case $opt in
        h) Help; exit 0;;
        i) checklist=$OPTARG;;
        x) extension=$OPTARG;;
        \?) echo "${R}Error: Invalid option${NC}";exit 1;;
    esac
done        

devel_list="installed.${extension}"
if [ ! -f $checklist ]; then echo "No list has selected"; exit 1; fi
if [ $extension -ne "dummy" ]; then echo "List of packages installed by ${extension}" > $devel_list; fi


while IFS= read -r line; do
  eval rosversion $line > /dev/null
  if [ $? -eq 0 ];
  then
    echo "$line:${G}$(rosversion $line)${NC}"
    echo "$line::$(rosversion $line)" >> $devel_list
  else
    echo "$line: ${R}Not found${NC}"
    echo "$line" >> temp
  fi
done < $checklist

echo "${Y}Check install.log for missing packages${NC}"
if [ ! -f "temp" ]; then echo "# No package to display" > temp; fi
mv temp to_install.log
unset Help
