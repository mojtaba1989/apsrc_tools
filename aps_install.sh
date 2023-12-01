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
   echo "-o     log file name, default:aps_tools.log"
   echo "-i     list file, default:github.list"
   echo
}

log_file="aps_tools.log"
workspace_name="apsrc_ws"
list="$PWD/github.list"

while getopts "n:ho:i:" opt; do
    case $opt in
        h) Help; exit 0;;
        o) log_file=$OPTARG;;
        n) workspace_name=$PWD/$OPTARG;;
        i) list=$OPTARG;;
        \?) echo "${R}Error: Invalid option${NC}";exit 0;;
    esac
done 

link="https://github.com/mojtaba1989/"
ext=".git"
CWD=$PWD
rm $log_file > /dev/null
exec 3<> $log_file

# Check if list file exist
cat $list 1>/dev/null 2>&3; if [ $? -ne 0 ]; then echo "${R}${list} cannot found in $CWD${NC}"; exit 1; fi

echo "${G}Found ${list} in $CWD ${NC}"
{
while IFS= read -r line; do
    tmp="${line#"$link"}" && echo "${tmp%"$ext"}"
done < $list
if [ -n "$line" ]; then
    tmp="${line#"$link"}" && echo "${tmp%"$ext"}" 
fi
}


# Creating Workspace
echo "${Y}Creating workspace - will replaced if exist${NC}"
if test -d /home/${USER}/${workspace_name}; then
    echo "${Y}${workspace_name} will be removed and recreated${NC}"
    sudo rm -r /home/${USER}/${workspace_name}
fi
mkdir -p /home/${USER}/${workspace_name}/src
echo "${Y}${workspace_name} created${NC}"

cd /home/${USER}/${workspace_name}/src
while IFS= read -r line; do
    eval git clone $line >/dev/null 2>&3
    if [ $? -eq 0 ]; then
        echo "$line ${G} OK ${NC}"
    else
        echo "$line ${G} Not Found${NC}"
    fi
done < $list
if [ -n "$line" ]; then
    eval git clone $line >/dev/null 2>&3
    if [ $? -eq 0 ]; then
        echo "$line ${G} OK ${NC}"
    else
        echo "$line ${R} Not Found${NC}"
    fi 
fi

cd ..
ls /home/${USER}/${workspace_name}/src -1 > catkin_pkg_list

if grep -q "msgs" catkin_pkg_list; then
    echo  "${Y} Installing:${NC} apsrc_msgs"
    catkin_make --pkg apsrc_msgs >&3
    if [ $? -eq 0 ];then
        echo  "apsrc_msgs ${G} Installed ${NC}"
    else
        echo  "apsrc_msgs ${R} Not Installed ${NC}"
    fi
fi

if grep -q "network" catkin_pkg_list; then
    echo  "${Y} Installing:${NC} network_interface"
    catkin_make --pkg network_interface >&3
    if [ $? -eq 0 ];then
        echo  "network_interface ${G} Installed ${NC}"
    else
        echo  "network_interface ${R} Not Installed ${NC}"
    fi
fi

if grep -q "apsrc_v2x_rosbridge" catkin_pkg_list; then
    echo  "${Y} Installing:${NC} apsrc_v2x_rosbridge"

    ldconfig -p | grep -q asn1609dot2
    if [ $? -eq 0 ];then
        echo  "asn1609dot2 ${G} Found ${NC}"
    else
        echo  "asn1609dot2 ${R} Not Found ${NC}"
        echo  "${Y} Installing:${NC} libasn1609dot2.so"
        sudo cp ./src/apsrc_v2x_rosbridge/libs/libasn1609dot2.so /usr/lib/
        sudo ldconfig
        ldconfig -p | grep -q asn1609dot2
        if [ $? -eq 0 ];then
            echo  "asn1609dot2 ${G} Installed ${NC}"
        else
            echo  "asn1609dot2 ${R} Not Installed ${NC}"
            echo "asn1609do2 is not installed" >&3
            exit 1
        fi
    fi

    ldconfig -p | grep -q asnj2735
    if [ $? -eq 0 ];then
        echo  "asnj2735 ${G} Found ${NC}"
    else
        echo  "asnj2735 ${R} Not Found ${NC}"
        echo  "${Y} Installing:${NC} asnj2735.so"
        sudo cp ./src/apsrc_v2x_rosbridge/libs/libasnj2735.so /usr/lib/
        sudo ldconfig
        ldconfig -p | grep -q asnj2735
        if [ $? -eq 0 ];then
            echo  "asnj2735 ${G} Installed ${NC}"
        else
            echo  "asnj2735 ${R} Not Installed ${NC}"
            echo "asnj2735 is not installed" >&3
            exit 1
        fi
    fi  
    catkin_make --pkg apsrc_v2x_rosbridge >&3
    if [ $? -eq 0 ];then
        echo  "apsrc_v2x_rosbridge ${G} Installed ${NC}"
    else
        echo  "apsrc_v2x_rosbridge ${R} Not Installed ${NC}"
    fi
fi

catkin_make >&3

while true; do
		read -p "Do you wish to source $workspace_name?(y/n)" yn
		case $yn in
			[Yy]* ) if grep -q "/home/${USER}/${workspace_name}/devel/setup.bash --extend" /home/${USER}/.bashrc; then echo "Already exist";
                    else
                        echo "source /home/${USER}/${workspace_name}/devel/setup.bash --extend" >> /home/${USER}/.bashrc;
                    fi
                    . /home/${USER}/.bashrc;
                    break;;
			[Nn]* ) break;;
			* ) break;;
		esac
done
(
echo "${Y}Version Report${NC}"
while IFS= read -r line; do
  eval rosversion $line > /dev/null
  if [ $? -eq 0 ];
  then
    echo "$line:${G}$(rosversion $line)${NC}"
  else
    echo "$line: ${R}Not found${NC}"
  fi
done < catkin_pkg_list
)
rm catkin_pkg_list

cd $CWD
exec 3>&-




