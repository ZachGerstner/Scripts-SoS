#!/bin/bash 

echo "Would you like to install or run the controller? 0=install 1=run"
read d

if [ $d -eq 0]
then
        sudo apt-get update
        git clone https://github.com/rizard/SOSForFloodlight.git -b sos-13
        sudo apt-get install build-essential default-jdk ant python-dev eclipse
        cd SOSForFloodlight/
        sudo ant
        sudo mkdir /var/lib/floodlight
        sudo chmod 777 /var/lib/floodlight

        echo 'Install successful! Dont forget to configure floodlightdefault.properties. To Identify ports and DPIDS use floodlight REST API!'

        echo 'curl http://<ip-of-controller>:8080/wm/devices | python -m json.tool'

        printf "would you like to run controller?\n Please ensure you are in the /SoSForFloodlight directory.\n 1=y 0=n"
        read x
        if [ $x -eq 1 ]
        then
                java -jar target/floodlight.jar
        elif [ $x -eq 0 ]
        then
                echo 'Have a wonderful day!'
        else
                echo 'Response not valid'
        fi
elif [ $d -eq 1 ]
then    
        java -jar target/floodlight.jar
else    
        echo 'Response not valid, Have a pleasent day!'
fi
