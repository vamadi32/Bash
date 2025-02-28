### IPSW Mac Reloader
A Bash script to restore MacBook/iOS/iPad devices using an IPSW file. The script leverages macvdmtool and Apple’s cfgutil command-line tool (installed via Apple Configurator 2) to facilitate the restoration process. Users can easily customize the folder paths and mode via command-line options.

### Prerequisites
Before running the script, please ensure you have completed the following:

1. Xcode Command Line Tools
Install Xcode Command Line Tools by running:

```
xcode-select --install

```
2. macvdmtool
Clone and build the macvdmtool repository:
```
git clone https://github.com/AsahiLinux/macvdmtool.git
cd macvdmtool && make
sudo cp macvdmtool /usr/local/bin

```

3.  Apple Configurator 2 and cfgutil
- Download and install Apple Configurator 2 from the Mac App Store.
- Open Apple Configurator 2, then in the top left click on Apple Configurator 2 > Install Automation Tools. This will install the cfgutil command-line 
  tool required by the script.
4.  Root Privileges

### Usage

1. Make the Script Executable

```
chmod +x ipsw_mac_reloader.sh

```
2. Run the Script with Optional Parameters

The script accepts the following command-line options:

-p: Path to the macvdmtool folder (default: $HOME/PrivateGitRepo/macvdmtool)
-m: Mode to use (default: dfu)
-i: IPSW file path (default: $HOME/IPSWs/UniversalMac_15.3.1_24D70_Restore.ipsw)
Example usage:
```
sudo ./ipsw_mac_reloader.sh -p /path/to/macvdmtool -m dfu -i /path/to/ipsw_file.ipsw

```

### How It Works

1.  The script first checks if it is being run as root.
2.  It then verifies that the cfgutil command is available.
3.  If the specified macvdmtool directory exists, it changes into that directory and executes the tool using the provided mode.
    After a short wait, it checks for attached devices using cfgutil list-devices.
4.  If a device is detected, it initiates the IPSW restore process.

### Troubleshooting
1. cfgutil Not Found:
   Ensure that you have installed Apple Configurator 2 and completed the “Install Automation Tools” step.

2. macvdmtool Directory Not Found:
   Verify that the directory path provided with the -p option exists or use the default path if the repository was cloned as described above.

3. Script Must Run as Root:
   Always run the script with sudo to avoid permission issues.


### Author
Victor Amadi

