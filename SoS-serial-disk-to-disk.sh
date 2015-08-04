#!/bin/bash
#Based on Qing's wget-serial-disk-to-disk.sh

SOURCE_IP=192.168.1.1   # NEED to be CHANGE to your own source apache server IP

START=`date +%s`                # disk-to-disk start time 
#echo $START            

##################################
# Start Wget Disk-to-Disk Transfer
##################################
echo "------ Start to get DNA data ------"
echo "" 

wget http://$SOURCE_IP/<name-of-tar>.tar   #<========NEED TO EDIT NAME!!!

END=`date +"%s"`        # disk-to-disk end time
#echo $END

TIME_DIFF=`expr $END - $START`
echo "It tooks $TIME_DIFF second to finish the disk-to-disk file transfer!!"

# calculate all the *sra files to get the total size 
TOTALSIZE=$( ls *.sra -lrt | awk '{ total += $5 }; END { print total }' )
echo "Total received DNA file size is: ${TOTALSIZE} byte\n"

# calculate disk-to-disk throughput 
THROUGHPUT=`echo $TOTALSIZE / $TIME_DIFF / 1024 / 1000 |bc -l`
echo "disk-to-disk throuput is: $THROUGHPUT MB/s"
