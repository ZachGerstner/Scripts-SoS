#!/bin/bash
#Based of Qing's wget-serial-disk-to-disk.sh

SOURCE_IP=130.14.250.13

echo "====Fetching Test Files===="
echo ""

for z in `seq 84 85`
do
        wget http://$SOURCE_IP/sra/sra-instant/reads/ByRun/sra/SRR/SRR039/SRR0398${z}/SRR0398${z}.sra
done

for c in `seq 26 33`
do
        wget http://$SOURCE_IP/sra/sra-instant/reads/ByRun/sra/SRR/SRR058/SRR0585${c}/SRR0585${c}.sra
done

echo "Test Files Successfully Transfered"
echo "Moving files to /var/www"

sudo mv *.sra /var/www

echo "Node now ready to transfer!"
echo "Do you want to generate the SoS tar file? 1=y 0=n"
read x

if [ $x -eq 1 ]
then
        cd
        cd /var/www/
        sudo tar -czf DNA.tar *.sra
elif [ $x -eq 0 ]
then
        echo "exiting now!"
else
        echo "Invalid input! Exiting now."
fi
