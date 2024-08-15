# install-aiscatcher

**This script does following:** </br>
**(1) Clones AIS-catcher source-code from [https://github.com/jvde-github/AIS-catcher](https://github.com/jvde-github/AIS-catcher)** </br>
**(2) Builds Linux executeable from source-code, & installs it in folder `/usr/local/bin/`** </br>
**(3) Creates Systemd service to automatically start AIS-catcher when RPi boots, and run AIS-catcher in background.** </br>
**(4) Provides Systemd commands to start stop, restart, and display status, and journalctl logs of AIS-catcher** </br>
### Command to view Log: 
`sudo journalctl -u aiscatcher -n 20 ` </br></br>

## INSTALL / UPGRADE / REINSTALL </br> Copy-paste following command in SSH console and press Enter key. </br> The script will Install / Upgrade / Reinstall _Latest Version_ of AIS-catcher and it's Systemd Service.  </br>

```
sudo bash -c "$(wget -O - https://raw.githubusercontent.com/abcd567a/install-aiscatcher/master/install-aiscatcher.sh)"

```

</br>

### AFTER INSTALLATION IS COMPLETED, PLEASE DO FOLLOWING: </br>
(1) If on RPi you have installed AIS Dispatcher or OpenCPN, </br>
    it should be configured to use UDP Port 10110, IP 127.0.0.1 OR 0.0.0.0 </br>

(2) Open file aiscatcher.conf by following command: </br>

``` 
sudo nano /usr/share/aiscatcher/aiscatcher.conf     

```
 </br>

The defalt content of above file are as shown below:  </br>

```
 -d 00000162
 -v 10
 -M DT
 -gr TUNER 38.6 RTLAGC off
 -s 2304k
 -p 3
 -o 4
 -u 127.0.0.1 10110
 -N 8383
 -N PLUGIN_DIR /usr/share/aiscatcher/my-plugins   

```

</br>

(3) In above file: </br>
     (a) Change 00000162 in "-d 00000162" to actual Serial Number of AIS dongle </br>
     (b) Change 3 in "-p 3" to the actual ppm correction figure of dongle </br>
     (c) Change 38.6 in "-gr TUNER 38.6 RTLAGC off" to desired Gain of dongle </br>
     (d) Add following line and replace xx.xxx and yy.yyy by actual values: </br>
          -N STATION MyStation LAT xx.xxx LON yy.yyy </br>
     (e) For each Site you want to feed AIS data, add a new line as follows: </br>
          -u [URL or IP of Site] [Port Number of Site] </br>
     (f) Save (Ctrl+o) and  Close (Ctrl+x) file aiscatcher.conf </br>

**IMPORTANT: If you are Upgrading or Reinstalling, your old config file is saved as** </br>
       **/usr/share/aiscatcher/aiscatcher.conf.old** </br>

(4) REBOOT RPi ... REBOOT RPi ... REBOOT RPi ... REBOOT RPi </br>

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
`received: 12 msgs, total: 59754 msgs, rate: 1.19834 msg/s ` </br> 

**Command:**  </br>
`sudo journalctl -u aiscatcher -n 200 | grep -o 'rate.*'  ` </br>
**Output:** </br>
`rate: 1.29752 msg/s`  </br>

**Command:** </br>
`sudo journalctl -u aiscatcher -n 30 | awk -F',' '{print $17}'  ` </br>
**Output:** </br>
`"ppm":4.340278`  </br>

**Command:** </br>
`sudo journalctl -u aiscatcher -n 30 | awk -F',' '{print $16}'  ` </br>
**Output:** </br>
`"signalpower":-46.787212`  </br>

### In above command's last part, i.e. in `{print $4}`, substitute `$4` by values listed in first column of the table below to get the output shown in second column of the table.

&nbsp;

| $n  |  Output  Example  |
|---|---|
| $1 | Jan 05 04:48:16 debian11 aiscatcher[38575]: [AIS engine v0.42 #0] </br>    received: 16 msgs </br> Jan 05 04:48:17 debian11 aiscatcher[38575]: {"class":"AIS"|
| $2 | "device":"AIS-catcher" |
| $3 | "rxtime":"20230105095333" |
| $4 | "scaled":true |
| $5 | "channel":"A" </br> "channel":"B" |
| $6 | "nmea":["!AIVDM |
| $7 | 3 |
| $8 | 1 |
| $9 | 4|
| $10 |  A </br> B |
| $11 | 14eIvM6P00rDSONHv0pf4?vR2@:2 </br> 8h30ot1?0@<BbDPPPP3D<oPPEU;M418T@00BbDPPPPC=DoN0lU:2WQ8v  |  
| $12 | 2*5C"] </br> 0*02"] |
| $13 | "signalpower":-41.644276 |
| $14 | "ppm":-3.761574 |
| $15 | "mmsi":316206000 |
| $16 | "status":5 |
| $17 | "status_text":"Aground" </br> "status_text":"Under way using engine" |

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

