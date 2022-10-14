#!/bin/bash

echo "Installing build tools and dependencies..."
sudo apt install -y git
sudo apt install -y make
sudo apt install -y gcc
sudo apt install -y g++
sudo apt install -y cmake
sudo apt install -y pkg-config
sudo apt install -y librtlsdr-dev

echo "Creating folder aiscatcher"
INSTALL_FOLDER=/usr/share/aiscatcher
sudo mkdir ${INSTALL_FOLDER}

echo "Entering install folder..."
cd ${INSTALL_FOLDER}

echo "Cloning source-code of AIS-catcher from Github and making executeable..."
git clone https://github.com/jvde-github/AIS-catcher.git
cd AIS-catcher
mkdir build
cd build
cmake ..
make
echo "Copying AIS-catcher binary in folder /usr/local/bin/ "
sudo cp ${INSTALL_FOLDER}/AIS-catcher/build/AIS-catcher /usr/local/bin/AIS-catcher

echo "Creating startup script file start-ais.sh"
SCRIPT_FILE=${INSTALL_FOLDER}/start-ais.sh
sudo touch ${SCRIPT_FILE}
sudo chmod 777 ${SCRIPT_FILE}
echo "Writing code to startup script file start-ais.sh"
/bin/cat <<EOM >${SCRIPT_FILE}
#!/bin/sh
CONFIG=""
while read -r line; do CONFIG="\${CONFIG} \$line"; done < ${INSTALL_FOLDER}/aiscatcher.conf
cd ${INSTALL_FOLDER}
/usr/local/bin/AIS-catcher \${CONFIG}
EOM
sudo chmod +x ${SCRIPT_FILE}

echo "Creating config file aiscatcher.conf"
CONFIG_FILE=${INSTALL_FOLDER}/aiscatcher.conf
sudo touch ${CONFIG_FILE}
sudo chmod 777 ${CONFIG_FILE}
echo "Writing code to config file aiscatcher.conf"
/bin/cat <<EOM >${CONFIG_FILE}
 -d 00000162
 -v 10
 -M DT
 -u 192.168.0.10 10101
 -u 5.9.207.224 12345
 -gr TUNER 25.4 RTLAGC off
 -s 2304k
 -p 34
 -o 4
EOM
sudo chmod 644 ${CONFIG_FILE}

echo "Creating User aiscat to run AIS-catcher"
sudo useradd --system aiscat
sudo usermod -a -G plugdev aiscat

echo "Assigning ownership of install folder to user aiscat"
sudo chown aiscat:aiscat -R ${INSTALL_FOLDER}

echo "Creating Service file aiscatcher.service"
SERVICE_FILE=/lib/systemd/system/aiscatcher.service
sudo touch ${SERVICE_FILE}
sudo chmod 777 ${SERVICE_FILE}
/bin/cat <<EOM >${SERVICE_FILE}
# AIS-catcher service for systemd
[Unit]
Description=AIS-catcher
Wants=network.target
After=network.target
[Service]
User=aiscat
RuntimeDirectory=aiscatcher
RuntimeDirectoryMode=0755
ExecStart=/bin/bash ${INSTALL_FOLDER}/start-ais.sh
SyslogIdentifier=aiscatcher
Type=simple
Restart=on-failure
RestartSec=30
RestartPreventExitStatus=64
Nice=-5
[Install]
WantedBy=default.target

EOM

sudo chmod 644 ${SERVICE_FILE}
sudo systemctl enable aiscatcher
sudo systemctl restart aiscatcher

echo " "
echo " "
echo -e "\e[32mINSTALLATION COMPLETED \e[39m"
echo -e "\e[32m=======================\e[39m"
echo -e "\e[32mPLEASE DO FOLLOWING:\e[39m"
echo -e "\e[32m=======================\e[39m"
echo -e "\e[31mREBOOT RPi \e[39m"
echo -e "\e[33m(2) Open file aiscatcher.conf by following command:\e[39m"
echo -e "\e[39m     sudo nano "${INSTALL_FOLDER}"/aiscatcher.conf \e[39m"
echo ""
echo -e "\e[33m(1) Modify following lines:\e[39m"
echo -e "\e[39m      -u 192.168.0.10 10101  \e[39m"
echo -e "\e[39m      -u 5.9.207.224 12345   \e[39m"
echo -e "\e[33mReplace IP and Port by your actual IP & Port \e[39m"
echo -e "\e[33mof Map Software and Feeding Site\e[39m"
echo ""
echo -e "\e[33m(2) Change \"-d 00000162\" to the actual Serial Number of your DVBT dongle\e[39m"
echo -e "\e[33mNOTE: Do NOT leave any blank spaces between lines\e[39m"
echo ""
echo -e "\e[33mSave (Ctrl+o) and  Close (Ctrl+x) file aiscatcher.conf \e[39m"
echo ""
echo -e "\e[33mthen restart AIS-catcher by following command:\e[39m"
echo -e "\e[39m     sudo systemctl restart aiscatcher \e[39m"
echo " "

echo -e "\e[32mTo see status\e[39m sudo systemctl status aiscatcher"
echo -e "\e[32mTo restart\e[39m    sudo systemctl restart aiscatcher"
echo -e "\e[32mTo stop\e[39m       sudo systemctl stop aiscatcher"
echo -e "\e[31m  REBOOT RPi \e[39m"
echo -e "\e[31m  REBOOT RPi \e[39m"

