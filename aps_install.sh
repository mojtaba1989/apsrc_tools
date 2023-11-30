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
   echo "APSRC packages install: MOJTABA BAHRAMGIRI APSRC Dec-30-2023"
   echo
   echo "Syntax: scriptTemplate [n|h|o|i]"
   echo "options:"
   echo "-n     workspace name, default: apsrc_ws"
   echo "-h     help."
   echo "-o     log file name, default:aps_tools_log"
   echo "-i     list file, default:github.list"
   echo
}

log_file="txt"
workspace_name="apsrc_ws"
list="github.list"

while getopts "n:ho:" opt; do
    case $opt in
        h) Help; exit 0;;
        o) log_file=$OPTARG;;
        n) workspace_name=$OPTARG;;
        i) list=$OPTARG;;
        \?) echo "${R}Error: Invalid option${NC}";exit 1;;
    esac
done 

devel_list="aps_tools_log.${extension}"
if [ $extension -ne "txt" ]; then echo "List of packages installed by aps tools under ${workspace_name}" > $log_file; fi

if test -f $list; then 
    echo "${G}Found ${list}${NC}"
else
    echo "${R}${list} cannot find${NC}"
    echo "${R}${list} cannot find${NC}" >> $log_file
    exit 1
fi

echo "${G}Creating workspace - will replaced if exist${NC}"
if test -d /home/${USER}/${workspace_name}; then
    echo "${Y}${workspace_name} will be removed and recreated${NC}"
    sudo rm -r home/${USER}/${workspace_name}
    mkdir -p home/${USER}/${workspace_name}/src
    if [ $? -ne 0 ]; then
        echo "${Y}${workspace_name} created${NC}"



