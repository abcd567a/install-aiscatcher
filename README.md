# install-aiscatcher

**This script does following:** </br>
**(1) Clones AIS-catcher source-code from [https://github.com/jvde-github/AIS-catcher](https://github.com/jvde-github/AIS-catcher)** </br>
**(2) Builds Linux executeable from source-code, & installs it in folder `/usr/local/bin/`** </br>
**(3) Creates Systemd service to automatically start AIS-catcher when RPi boots. It also provides Systemd commands to start stop, restart, and status** </br>

</br>

### Copy-paste following command in SSH console and press Enter key. The script will install and configure AIS-catcher.  </br>

```
sudo bash -c "$(wget -O - https://raw.githubusercontent.com/abcd567a/install-aiscatcher/master/install-aiscatcher.sh)"

```

</br>

### AFTER INSTALLATION IS COMPLETED, PLEASE DO FOLLOWING: </br>
**REBOOT YOUR PI** </br>
**REBOOT YOUR PI** </br>
**REBOOT YOUR PI** </br></br>
Open file aiscatcher.conf by following command: </br>
 
     sudo nano /usr/share/aiscatcher/aiscatcher.conf 

(1) Modify following lines:
      -u 192.168.0.10 10101
      -u 5.9.207.224 12345
Replace IP and Port by your actual IP & Port
of Map Software and Feeding Site

(2) Change "-d 00000162" to the actual Serial Number of your DVBT dongle

**NOTE: Do NOT leave any blank spaces between lines**

Save (Ctrl+o) and  Close (Ctrl+x) file aiscatcher.conf

then restart AIS-catcher by following command:
     sudo systemctl restart aiscatcher

To see status `sudo systemctl status aiscatcher `  </br>
To restart    `sudo systemctl restart aiscatcher ` </br>
To stop       `sudo systemctl stop aiscatcher ` </br>

</br>
