#!/bin/bash
sudo apt-get update
sudo apt-get install clang uuid-dev libxml2-dev -y
git clone git://github.com/aaronorosen/SteroidOpenFlowService.git

#issue here with cding into the dir
cd SteroidOpenFlowService/

git submodule init
git submodule update
cd sos-agent/
make

sh ~/SteroidOpenFlowService/sos-agent/run.sh
