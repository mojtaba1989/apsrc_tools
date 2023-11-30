#!/bin/sh
echo Complementary package installation: MOJTABA BAHRAMGIRI APSRC Jun-27-2022 > install.log 
while IFS= read -r line; do 
 temp=$(echo ros-$ROS_DISTRO-$line | tr '_' '-')
 eval sudo apt install $temp >> install.log 2>&1
 if [ $? -eq "0" ]; then
  echo "${line}: Installed successfully"
  echo "Check for rosversion ${line} ..."
  eval rosversion $line
 else
  echo "${line}: Failed to install"
  echo "Check for rosversion ${line} ..."
  eval rosversion $line
  if [ $? -ne 0 ]; then
   package_exist=1
   while IFS= read -r address; do
    if [[ "$line" == *"$address"* ]]; then
     temp_git=$(echo $address | sed 's/^.*:://')
     eval git clone $temp_git
     if [ $? -ne 0 ]; then echo "${line}: error in git clone" fi
     if [ $? -eq 0 ]; then
      echo "${line}: repo has been found"
      file=$(echo ls -td /* | head -1)
      mv -r $file ~/catkin_ws/src
      echo "${line}: repo has moved to Catkin Workspace"
      package_exist=0
    fi
   done < $2
   if [ $package_exist -ne 0 ]; then echo "${line}: repo could not be found" fi
  fi
 fi
done < $1
cd ~/catkin_ws
echo "Moved to catkin_ws directory"
eval catkin_make
echo "New Packages build is completed"
eval "source ~/catkin_ws/devel/setup.bash"

