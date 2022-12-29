# install-aiscatcher

**This script does following:** </br>
**(1) Clones AIS-catcher source-code from [https://github.com/jvde-github/AIS-catcher](https://github.com/jvde-github/AIS-catcher)** </br>
**(2) Builds Linux executeable from source-code, & installs it in folder `/usr/local/bin/`** </br>
**(3) Creates Systemd service to automatically start AIS-catcher when RPi boots, and run AIS-catcher in background.** </br>
**(4) Provides Systemd commands to start stop, restart, and display status, and journalctl logs of AIS-catcher** </br>
### Command to view Log: 
`sudo journalctl -u aiscatcher -n 20 ` </br></br>

## INSTALLATION: Copy-paste following command in SSH console and press Enter key. The script will install AIS-catcher and it's Systemd Service.  </br>

```
sudo bash -c "$(wget -O - https://raw.githubusercontent.com/abcd567a/install-aiscatcher/master/install-aiscatcher.sh)"

```

</br>

### AFTER INSTALLATION IS COMPLETED, PLEASE DO FOLLOWING: </br>
(1) If on RPi you have installed AIS Dispatcher or OpenCPN,</br>
    it should be configured to use UDP Port 10110, IP 127.0.0.1 OR 0.0.0.0 </br>
(2) Open file aiscatcher.conf by following command:</br>
    sudo nano /usr/share/aiscatcher/aiscatcher.conf  </br>
(3) In above file: </br>
    (a) Change 00000162 in "-d 00000162" to actual Serial Number of AIS dongle </br>
    (b) Change 3 in "-p 3" to the actual ppm correction figure of dongle </br>
    (c) Change 38.6 in "-gr TUNER 38.6 RTLAGC off" to desired Gain of dongle </br>
    (d) Add following line and replace xx.xxx and yy.yyy by actual values: <br>
        -N STATION MyStation LAT xx.xxx LON yy.yyy </br>
    (e) For each Site you want to feed AIS data, add a new line as follows: </br>
                    -u [URL or IP of Site] [Port Number of Site]  </br>
    (f) Save (Ctrl+o) and  Close (Ctrl+x) file aiscatcher.conf  </br>
(4) REBOOT RPi </br> REBOOT RPi </br>

(5) See the Web Interface (Map etc) at </br>
        10.0.0.100:8383  (IP-of-PI:8383) </br>

(6) Command to see Status sudo systemctl status aiscatcher </br>
(7) Command to Restart    sudo systemctl restart aiscatcher </br>
(8) Command to Stop       sudo systemctl stop aiscatcher </br>

</br>

### Determining the PPM Correction (for use in file `aisctacher.conf`) </br>

(1) Install test software </br>
`sudo apt install rtl-sdr  ` </br>

(2) Determin the device index of the dongle for AIS-catcher by following command </br>
`rtl_test -t`  </br>

(3) The device index will be 0 or 1, or 2 etc. </br>
Use following command to determine ppm  </br>
**NOTE:** Replace `n` in command below by device index you found above </br>
`rtl_test -d n -p60 ` </br>

(4) Wait until the cumulative error value (in PPM) remains more-or-less the same for three consecutive minutes. </br>
Note the last cumulative error value (in PPM) and use it in config of AIS-catcher.</br>
For example if the value determined by above test is 7, the entry in config file will be `-p 7` </br>

</br>

## Logs:
### Command to view full Log: 
`sudo journalctl -u aiscatcher -n 20 ` </br></br>

### Commands to view specific parts of log:

**Command:**  </br>
`sudo journalctl -u aiscatcher -n 200 | grep -o 'received.*'  ` </br>
**Output:** </br>
`received: 12 msgs, total: 59754 msgs, rate: 1.19834 msg/s ` </br> </br>

**Command:**  </br>
`sudo journalctl -u aiscatcher -n 200 | grep -o 'rate.*'  ` </br>
**Output:** </br>
`rate: 1.29752 msg/s`  </br></br>

**Command:** </br>
`sudo journalctl -u aiscatcher -n 30 | awk -F',' '{print $4}'  ` </br>
**Output:** </br>
`"ppm":4.340278`  </br>

### In above command's last part, i.e. in `{print $4}`, substitute `$4` by values listed in first column of the table below to get the output shown in second column of the table.

&nbsp;

| $n  |  Output  Example  |
|---|---|
| $1 | Oct 25 12:09:56 debian11 aiscatcher[3304]: {"rxtime":"20221025160956" </br> Oct 25 12:46:20 debian11 aiscatcher[3304]: [AIS engine v0.38 ]                     received: 11 msgs |
| $2 | "channel":"A"  </br>  total: 58298 msgs |
| $3 | "signalpower":-47.659782 |
| $4 | "ppm":1.736111 |
| $5 | "type":1 |
| $6 | "mmsi":316023269 |
| $7 | "status":0 |
| $8 | "status_text":"Under way using engine" |
| $9 | "epfd":7 </br> "speed":8.100000 </br> "turn":0|
| $10 |  "accuracy":true </br> "shipname":"M.V. RIVER GAMBLER"  </br> "speed":12.800000 |
| $11 | "lon":-79.396454 </br> "accuracy":true  |  
| $12 | "lat":43.635452 |
| $13 | "course":52.500000} |
| $14 | "course":256.600006 |
| $15 | "heading":257} |
| $16 | "to_port":21 |
| $17 | "to_starboard":3 |

&nbsp;

## To Uninstall AIS-catcher AND remove all its files

**STEP-1: Stop & disable aiscatcher service, and remove aiscatcher service file.**

```
sudo systemctl stop aiscatcher  

sudo systemctl disable aiscatcher  

sudo rm /lib/systemd/system/aiscatcher.service  

```

&nbsp;

**STEP-2: Remove files and folders pertaining to AIS-catcher.**

```
sudo rm -rf /usr/share/aiscatcher

sudo rm /usr/local/bin/AIS-catcher

sudo userdel aiscat   

```

&nbsp;

