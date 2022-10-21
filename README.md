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
1. The Map Software installed on RPi(AIS Dispatcher or OpenCPN) should </br>
    be configured to use UDP Port 10110, IP 127.0.0.1 OR 0.0.0.0 </br>
    
2. Open file aiscatcher.conf by following command: </br>
       `sudo nano /usr/share/aiscatcher/aiscatcher.conf  ` </br>
       
3. In above file: </br>
   (a) Change 00000162 in "-d 00000162" to actual Serial Number of AIS dongle </br>
   (b) Change 3 in "-p 3" to the actual ppm correction figure of AIS dongle </br>
   (c) Change 38.6 in \"-gr TUNER 38.6 RTLAGC off\" to desired Gain for AIS dongle </br>
   (d) For each Site you want to feed AIS data, add a line immediately below the </br>
       last line, in following format: </br>
         `-u [URL or IP of Site] [Port Number of Site] ` </br>
    NOTE: Do NOT leave any blank spaces between lines </br>
    (e) **Save (Ctrl+o)** and  Close (Ctrl+x) file aiscatcher.conf </br>
        
5.  **REBOOT RPi** </br>
  **REBOOT RPi** </br>
  **REBOOT RPi** </br>

6. **AFTER REBOOT**, you can use following commands: </br>
To see status: `sudo systemctl status aiscatcher `  </br>
To restart:    `sudo systemctl restart aiscatcher ` </br>
To stop:       `sudo systemctl stop aiscatcher ` </br>

</br>
