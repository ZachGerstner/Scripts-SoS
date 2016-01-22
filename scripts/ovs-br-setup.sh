#!/bin/bash
#EDIT THIS BEFORE USE!!!!
CONTROLLER_IP=130.127.38.2
CONTROLLER_PORT=6011
DESIRED_IP=192.168.1.1/24
VLAN= (ifconfig | awk '{print $1;}' | grep "vlan") 
#####################################################################
#Should be Automatic From this point on                             #
#####################################################################
echo 'Ensure the following are correct :'
echo "	1. The script variables are set to the correct addresses.
	2. That ovs is properly installed (ovs-vswitchd --version)
	3. The controller has been properly configured and is running"
echo 'You have 5 seconds to exit if any of the above criteria are not met.'

sleep 5

sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-port br0 $VLAN
sudo ifconfig $VLAN 0 up
sudo ifconfig br0 $DESIRED_IP up
sudo ovs-vsctl set-controller br0 tcp:$CONTROLLER_IP:$CONTROLLER_PORT
sudo ovs-vsctl show
echo 'Does the bridge look correct? 0=n 1=y'
read x 

if [ $x -eq 0 ]
then 
	echo 'Check to make sure Sudo permissions are correct'
	echo 'Also ensure that ovs is properly installed (ovs-vswitchd --version)'
	exit
elif [ $x -eq 1 ] 
then
	ping -c 3 $CONTROLLER_IP
	
	echo 'Was the ping successful? 0=n 1=y'
	read y

	if [ $y -eq 0 ]
	then 
		echo 'Check that the controller is running, and if the switches are connecting'
		exit
	elif [ $y -eq 1 ] 
	then
		echo 'Installing SoS Agents now...'
		sudo git clone http://github.com/cbarrin/sos-agent 
		cd ./sos-agent
		make 
		./run.sh
	else
		echo 'Input not recognized! Exiting now'
		exit
	fi
else 
	echo 'Invalid input! Exiting now.'
fi

