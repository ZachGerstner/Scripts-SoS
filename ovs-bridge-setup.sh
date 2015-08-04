#!/bin/bash

echo 'Are you configuring an agent or a swtich node? 0=node 1=switch'
read x

if [ $x -eq 0 ]
then
        printf "Ensure that the IP of your controller and the desired ips have been adjusted in this script before continuing.\n 1=Continue 0=Exit"
        read c
        if [ $c -eq 1]
        then
                sudo ovs-vsctl add-br agent-bar
                sudo ovs-vsctl add-port agent-br eth1
                sudo ovs-vsctl set-fail-mode agent-br standalone
                sudo ovs-vsctl set-controller agent-br tcp:<your-controller-ip-here>:6653   #EDIT THIS LINE

                sudo ifconfig eth1 0
                sudo ifconfig agent-br <your-desired-ip> netmask 255.255.255.0 up    #EDIT THIS LINE

                sudo ovs-vsctl show
                sudo ifconfig
                echo 'You should see the new ovs bridge and its ports printed above! Exiting now, have a pleasant day.'

        elif [ $c -eq 0 ]
        then
                printf "Use ifconfig on your controller machine to find its ip!\n Exiting have a pleasant day!\n"
        else
                echo 'Input invalid! Exiting now, have a pleasant day.'
        fi
elif [ $x -eq 1 ]
then
        printf "Ensure that the Controller IP and your desired IP have been edited before continuing.\n 1=Continue 0=Exit"
        read f
        if [ $f -eq 1]
        then    
                sudo ifconfig eth1 0
                sudo ifconfig eth2 0
                sudo ifocnfig eth3 0
        
                sudo ovs-vsctl add-br br0
                sudo ovs-vsctl add-port br0 eth1
                sudo ovs-vsctl add-port br0 eth2
                sudo ovs-vsctl add-port br0 eth3
        
                sudo ovs-vsctl set-fail-mode br0 secure
                #EDIT THE FOLLOWING TWO LINES
                sudo ovs-vsctl set-controller br0 tcp:<your-controller-ip>:6653
                sudo ifconfig br0 <ip-you-choose> netmask 255.255.255.0 up
                
                sudo ovs-vsctl show
                sudo ifconfig

                echo 'You should see the new ovs bridge printed above! Exiting now, have a pleseant day!'
        elif [ $f -eq 0 ]
                printf "Use ifconfig on your controller machine to find its IP!\n Exiting, have a pleasant day!\n"
        else
                echo 'Invalid imput! Exiting now, have a pleseant day!'
        fi
else
        echo 'Invalid imput! Exiting now, have a good day!'
fi
