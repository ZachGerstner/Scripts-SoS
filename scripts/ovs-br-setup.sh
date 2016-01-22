#!/bin/bash
#EDIT THIS BEFORE USE!!!!
CONTROLLER_IP=130.127.38.2
CONTROLLER_PORT=6011
DESIRED_IP=192.168.1.1/24
#####################################################################
#Should be Automatic From this point on  more or less               #
#####################################################################
echo 'Before running this script check the following :'
echo "	1. The script variables are set to the correctly.
	2. Ovs is properly installed (ovs-vswitchd --version)
	3. The controller has been properly configured and is running"
echo 'You have 5 seconds to exit if any of the above criteria are not met.'

sleep 5

echo 'Building Bridge...'
sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-port br0 $(ifconfig | awk '{print $1;}' | grep "vlan")
sudo ifconfig $(ifconfig | awk '{print $1;}' | grep "vlan") 0 up
sudo ifconfig br0 $DESIRED_IP up
sudo ovs-vsctl set-controller br0 tcp:$CONTROLLER_IP:$CONTROLLER_PORT
sudo ovs-vsctl show
ifconfig | grep "br0"
echo 'Is the bridge and ports properly configured? 0=n 1=y'
read x 

if [ $x -eq 0 ]
then 
	echo 'Debugging tips :'
	echo "	1. Sudo permissions improperly set.
		2. OVS is not installed 
		3. Terminal misprint [manually check values maybe correct]"
	exit
elif [ $x -eq 1 ] 
then
	ping -c 3 $CONTROLLER_IP
	
	echo 'Were you able to communicate with the Controller? 0=n 1=y'
	read y

	if [ $y -eq 0 ]
	then 
		echo 'Debugging Tips :'
		echo "	1. The switches are not connected with controller.
			2. Flows are not entering controller.
			3. HP switch."
		exit
	elif [ $y -eq 1 ] 
	then
		#something wrong with the make...
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

