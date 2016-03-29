#!/bin/bash
#EDIT THIS BEFORE USE!!!!
CONTROLLER_IP=130.127.38.2
CONTROLLER_PORT=6011
DESIRED_IP=192.168.2.1/24
PARTNER_IP=192.168.2.2 #any other machine in the topology
#Go To line 56 change the perl command as needed
#####################################################################
#Should be Automatic From this point on  more or less               #
#####################################################################
echo 'Before running this script check the following :'
echo "	1. The script variables are set correctly.
	2. Ovs is properly installed (ovs-vswitchd --version)
	3. The controller has been properly configured and is running"
echo 'You have 5 seconds to exit to make any necessary adjustments.'

sleep 5

echo 'Warning: This script was built for installing sos agents in cloudlab and Geni.'
echo '		Please report any missing dependencies to <someemailhere>'
echo 'Warning: This script will run t0 completion with only pauses to check output.'
echo '		For interactive install use ovs-interactive-setup.sh'
echo 'Checking and installing necessary dependencies...'
sudo apt-get update
cg=$(sudo apt --installed list | grep "clang")
uu=$(sudo apt --installed list | grep "uuid-dev")
lx=$(sudo apt --installed list | grep "libxml2-dev")
if [ -z $cg ] || [ -z $uu ] || [-z $lx ];
then
	sudo apt-get install clang -y
	sudo apt-get install uuid-dev -y
	sudo apt-get install libxml2-dev -y
else
	echo 'Dependency install complete, 5 second rest to exit should errors occur.'
	sleep 5
fi

echo 'Building Bridge...'
sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-port br0 $(ifconfig | awk '{print $1}' | grep "vlan")
sudo ifconfig $(ifconfig | awk '{print $1}' | grep "vlan") 0 up
sudo ifconfig br0 $DESIRED_IP up
sudo ovs-vsctl set-controller br0 tcp:$CONTROLLER_IP:$CONTROLLER_PORT
sudo ovs-vsctl show
ifconfig br0 

sleep 5

ping -c 3 $PARTNER_IP
ping -c 3 $CONTROLLER_IP

sleep 5

echo 'Installing SoS Agents now...'
sudo git clone http://github.com/cbarrin/sos-agent 
cd ./sos-agent
sudo perl -p -i -e 's/10.0.255/192.168.2/g' ./common.h
sudo make 
echo 'Instillation complete.'
echo 'To run the SoS agent run ./run.sh.'
echo 'Recommended that you do so from a screen session.'
