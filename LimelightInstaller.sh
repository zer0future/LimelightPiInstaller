#!/bin/bash

mkdir ~/limelight

cd ~/limelight

read -p "Press anykey to start Java8 install, input sudo credentials when asked `echo $'\n> '`" -n1 -s

sudo apt-get update && sudo apt-get install oracle-java8-jdk && sudo apt-get install input-utils

wget https://github.com/irtimmer/limelight-embedded/releases/download/v1.2.1/libopus.so

wget https://github.com/irtimmer/limelight-embedded/releases/download/v1.2.1/limelight.jar

clear

echo -e "\nDiscovering GeForce PC:s, when found you can press ctrl+c to stop the search, or it will take a long time \n"

java -jar limelight.jar discover

echo -e "\n"

read -p "Input ip-address given above (if no IP is shown, press CTRL+C and check host connection) :`echo $'\n> '`" ip

java -jar limelight.jar pair $ip

read -p "Press any key to continue after you have given the passcode to the Host PC... `echo $'\n> '`" -n1 -s

read -p "Please ensure that your gamepad is connected to the PI for device selection (number only!), press any key to continue... `echo $'\n> '`" -n1 -s

clear

lsinput|grep -e dev.input.event -e name

echo -e "\nInput device event ID-number that corresponds with your gamepad from above for keymapping \n"
read -p "(if the gamepad is missing, press CTRL+C and reboot the PI with the game pad attached) :`echo $'\n> '`" USBID

java -jar limelight.jar map -input /dev/input/event$USBID mapfile.map

read -p "Existing limelight start scripts made with this installer will be removed, and new ones created in their place, press anykey to continue `echo $'\n> '`" -n1 -s

rm limelight720p60fps.sh
rm limelight1080p30fps.sh
rm limelight1080p60fps.sh


echo "#!/bin/bash" >> limelight720p60fps.sh
echo "cd ~/limelight/ && java -jar limelight.jar stream -720 -60fps "$ip" -app Steam -mapping mapfile.map" >>  limelight720p60fps.sh

echo "#!/bin/bash" >> limelight1080p30fps.sh
echo "cd ~/limelight/ && java -jar limelight.jar stream -1080 -30fps "$ip" -app Steam -mapping mapfile.map" >>  limelight1080p30fps.sh

echo "#!/bin/bash" >> limelight1080p60fps.sh
echo "cd ~/limelight/ && java -jar limelight.jar stream -1080 -60fps "$ip" -app Steam -mapping mapfile.map" >>  limelight1080p60fps.sh

chmod +x limelight720p60fps.sh
chmod +x limelight1080p30fps.sh
chmod +x limelight1080p60fps.sh
