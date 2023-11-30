# Vehicle Build

This repo is created for rebuilding the Instrumented Pacifica and RAM Spectra

# Creating a Disk Image
Creating a disk image demands unmounting the disk, which in case of OS container disk, forcing to unmount may damage system files.
A proper technique is to boot the Spectra from a bootable flash drive. In this case, we can create the image safely.

**The same approach can be used to recover from an old disk image.**

Requirements:
1. Bootable flash drive with ubuntu (preference: Ubuntu 18.04 bionic)
2. External hard drive with at least 251 GB free space

## Instruction
1. If you have a bootable flash drive, skip this step
  * The instruction for making a bootable flashdrive can be found [here](https://ubuntu.com/tutorials/create-a-usb-stick-on-windows#1-overview)
  * Ubuntu 18.04 can be downloaded from [here](https://releases.ubuntu.com/18.04/ubuntu-18.04.6-desktop-amd64.iso)
  * balenEtcher is recommended sofware to write ubuntu image on flash drive. Link to download [balenEtcher](https://www.balena.io/etcher/)
2. Reboot Spectra and boot it from Ubuntu containing flash drive. Select _try ubuntu without install_
3. Mount the external hard drive
4. Open _Disks_ and select OS containing Disk (the disk that you want to create the image from) from left menue
5. Select more options from top right corner and select _Create Disk Image..._ 

 <img src="https://github.com/mojtaba1989/apsrc_tools/blob/master/docs//Screenshot1.png" alt="Disks" width="400"/>
                
7. Select the external hard drive as the destination for creating disk image. This process will take about 20~40 mins
8. Reboot the Spectra 

# Re-build Spectra from source

To re-build Spectra from and old image, follow the previous section. Instead of creating an image, format the target disk and _Restrore Disk Image..._

To build from source, assure you have a backup from the current OS disk.

Sofware versions:
* Ubuntu 18.04 bionic
* Nvidia driver 470.129.06
* Cuda 10.0.130
* ROS melodic
* Autoware.ai 1.14.0

# Installation

## Installing Ubuntu and Nvidia driver

1. Use bootable flash drive containing Ubuntu 18.04 to format device and install ubuntu
2. Setup Wi-Fi connection, and connect the Spectra to high speed internet 
3. After installing ubuntu update the os, and install utilities 
```
sudo apt update
sudo apt install -y vim git openssh-server curl
```
4. Check compatible Nvidia drivers and install the driver
```
ubuntu-drivers devices
sudo apt install -y nvidia-driver-470
```
_replace 470 with the proper version (recommended 450, 460, and 470)_

5. reboot
```
sudo reboot
```
6. Check if NVIDA driver is installed successfully. 
```
nvidia-smi
```
_sample proper returned message_

<img src="https://github.com/mojtaba1989/apsrc_tools/blob/master/docs//nvidia-smi.png" alt="Disks" width="400"/>

## Installing CUDA 10

To download, instaall, and verfy the installation, follow these steps. [(source)](https://developer.nvidia.com/cuda-10.0-download-archive?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=runfilelocal)
```
wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux
mv cuda_10.0.130_410.48_linux cuda_10.0.130_410.48_linux.run
sudo sh cuda_10.0.130_410.48_linux.run
```
Please note, select "No" for _Install NVIDIA Accelerated Graphics Driver_

Installation option:

 1. press 'Q' to skip the reading
 2. type 'accept' and enter
 3. press 'n' and enter # Install NVIDIA Accelerated Graphics Driver for Linux-x86_64 410.48? 'n'
 4. press 'y' and enter
 5. press 'enter'
 6. press 'y' and enter
 7. press 'enter'
 8. press 'y' and enter
 9. press 'y' and enter
 10. press 'enter'

Open Bashrc file and 'sudo vim ~/.bashrc' and paste
```
export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```
Reboot the Spectra and check the cuda installation
```
sudo reboot
nvcc -V
```
Install cuDNN
Download binary files (latest version for CUDA 10.0.130). For downloading the files, you need to sign in.
```
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/7.6.4.38/Production/10.0_20190923/Ubuntu18_04-x64/libcudnn7_7.6.4.38-1%2Bcuda10.0_amd64.deb
wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/7.6.4.38/Production/10.0_20190923/Ubuntu18_04-x64/libcudnn7-dev_7.6.4.38-1%2Bcuda10.0_amd64.deb
```
After downloading the _deb_ files, install the runtime libraries, and then development libraries.

## Installing ROS Melodic

This instruction is based on [ROS Doc](http://wiki.ros.org/melodic/Installation/Ubuntu)

1. Configure you Ubuntu repositories

Configure your Ubuntu repositories to allow "restricted," "universe," and "multiverse." [guid](https://help.ubuntu.com/community/Repositories/Ubuntu)

2. Setup your sources.list
```
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
```

3. Set up the keys
```
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
```

4. Installation
```
sudo apt update
sudo apt install ros-melodic-desktop-full
```

5. Environment setup
```
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```

6. Check ROS version
```
rosversion -d
```

7. Dependencies for building packages
```
sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo rosdep init
rosdep update
```

## Installing Autoware.ai 1.14.0

This instrauction is based on [Autoware.ai doc](https://github.com/autowarefoundation/autoware_ai_documentation/wiki/Source-Build)

1. System dependencies for Ubuntu 18.04 / Melodic
```
sudo apt update
sudo apt install -y python-catkin-pkg ros-$ROS_DISTRO-catkin
sudo apt install -y python3-pip python3-colcon-common-extensions python3-setuptools python3-vcstool
pip3 install -U setuptools
```

2. Eigen Update
```
cd && wget https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.gz
mkdir eigen && tar --strip-components=1 -xzvf eigen-3.3.7.tar.gz -C eigen #Decompress
cd eigen && sudo mkdir build && cd build && sudo cmake .. && sudo make && sudo make install
cd && sudo rm -rf eigen-3.3.7.tar.gz && sudo rm -rf eigen
```

Check eigen version
```
pkg-config --modversion eigen3
```
4. Build Autoware.ai
  * Create a workspace
  ```
  mkdir -p autoware.ai/src
  cd autoware.ai
  ```

  * Downlaod source files
  ```
  wget -O autoware.ai.repos "https://raw.githubusercontent.com/autowarefoundation/autoware.ai/1.14.0/autoware.ai.repos"
  ```
  
  * Download Autoware.AI into the workspace
  ```
  vcs import src < autoware.ai.repos
  ```
  Alternative method (recommended)
  Copy _/src_ folder from backups into _~/autoware.ai/_.

  * Install dependencies using _rosdep_
  ```
  rosdep update
  rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
  ```

  * Compile the workspace using CUDA
  ```
  AUTOWARE_COMPILE_WITH_CUDA=1 colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
  ```

  * Setup the environment
  ```
  sudo echo "source ~/autoware.ai/install/setup.bash --extend" >> ~/.bashrc
  source ~/autoware.ai/install/setup.bash --extend
  ```
  
  * Create Symlink for Apolo
  ```
   cd ~/autoware.ai/install/lidar_apollo_cnn_seg_detect/share/lidar_apollo_cnn_seg_detect/
   mkdir launch
  ln -s ~/autoware.ai/src/core_perception/lidar_apollo_cnn_seg_detect/launch/lidar_apollo_cnn_seg_detect.launch ./launch
  ```


## AStuff packages

Now, you require to install extra packages, which haven't installed yet. There are four sets of packages which we need to install manualy:
1. open-source packages which can be installed by _apt_
2. open-source packages which cab be built using _Catkin_
3. open-source packages which can be built using _Colcon_
4. AStuff developed packages

However, not all the open-source packages are available for _bionic melodic_ combindation. Accordingly, we need a disk image to copy the missing packages manually. To facilitate this process, you can use APSRC developed scripts.

### APSRC Tools

1. Clone _apsr tools_ from github
```
cd && git clone https://github.com/APSRC/vehicle_build.git
```

2. Check for missing packages
```
cd vehicle_build/apsrc_tools
sh check_pkg.sh requirements.list
```

3. Try apt to install missing packages
```
sh apt_install.sh
```

4. Building missing packages using _catkin_
 ```
 cd && mkdir -p standard_ws/src
 cd standard_ws/src
 sudo cp /media/<user_machine>/<image>/home/<user_image>/<workspace>/src ~/standard_ws/src
 ```
 * Before building the package we need to clone "cam_lidar_calibration" from [Github](https://github.com/acfr/cam_lidar_calibration)
 ```
 git clone -c http.sslverify=false https://gitlab.acfr.usyd.edu.au/its/cam_lidar_calibration.git
 sudo apt update && sudo apt-get install -y ros-melodic-pcl-conversions ros-melodic-pcl-ros ros-   melodic-tf2-sensor-msgs
 pip install pandas scipy
 ```
 * Build packages from source codes
 ```
 catkin_init_workspace
 cd .. && catkin_make
 ```
 * Setup the environment
  ```
  sudo echo "source ~/standard_ws/devel/setup.bash --extend" >> ~/.bashrc
  source ~/standard_ws/devel/setup.bash --extend
  ```
  **Please Note, if standard_ws aleardy exists on you machine, avoid modifiying or rebuilding the environment. Instead, create a new environment to build the packages and add the corresponding PATH to _~/.bashrc_.**
  
5. Next is to move required binary files from provided disk image into your machine
 * update missing packages list
 ```
 cd ~/vehicle_build/apsr_tools
 sh check_pkg.sh
 cat install.log
 ```
 * Excluding _gpsins-localizer_, _ll2-global-planner_, and _stanley-controller_, the rest of packages can be deployed using _cp_ command
 ```
 sh cp_pkg.sh <package_name>
 ```
 You need to repeat this step for all missing ros packages which you want to copy built pkg.
 
6. Finally, check Autoware.AI src files for the missing components and copy the source files into corresponding directory. Next, you need to rebuild the colcon environment
```
AUTOWARE_COMPILE_WITH_CUDA=1 colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
```




