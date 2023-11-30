#!/bin/sh

package=$1
destination="/opt/ros/melodic"
home=$PWD

remove_files () {
	eval "sudo find $destination -iname $package -type d" > list
	while read adr; do
		eval "sudo rm -r $adr"
		echo "[REMOVED] $adr"
	done < list
}
address=$(sudo find /media -iname melodic -type d)
eval "sudo find $address -iname $package -type d" > list
while read loc; do
        temp_adr=$(echo $loc | sed 's/^.*opt/opt/')
        orig_adr=${loc#"$address"}
        temp_adr="/$temp_adr"
        dest_adr=${temp_adr%"$package"}
        sudo cp -r $loc $dest_adr
	echo "[COPIED] $loc"
done < list
eval "sudo find $destination -iname $package -type d" > list
echo "Check package version"
eval "rosversion $package"
if [ $? -eq 0 ]; then
        echo "${package} is installed successfully"
else
        echo "${package} installation is incomplete"
	while true; do
		read -p "Do you wish to remove the copied files?(y/n)" yn
		case $yn in
			[Yy]* ) remove_files; break;;
			[Nn]* ) sudo rm list; exit;;
			* ) sudo rm list; exit;;
		esac
	done
fi        
rm list
