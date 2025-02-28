#!/usr/bin/env bash
###
#
#            Name:  ipsw_mac_reloader.sh
#     Description:  Restore MacBook/iOS/iPad using IPSW with user-definable paths and mode.
#         Created:  2025-01-23
#   Last Modified:  2025-02-28
#         Version:  0.2.0
#
# Copyright Victor Amadi
#
########## Default Variables ##########
DEFAULT_MAC_VDM_PATH="$HOME/PrivateGitRepo/macvdmtool"
DEFAULT_MODE="dfu"
DEFAULT_IPSW_FILE="$HOME/IPSWs/UniversalMac_15.3.1_24D70_Restore.ipsw"

########## Usage Function ##########
usage() {
    echo "Usage: $0 [-p macVDMPath] [-m mode] [-i ipsw_file]"
    echo "  -p    Path to macvdmtool folder (default: ${DEFAULT_MAC_VDM_PATH})"
    echo "  -m    Mode to use (default: ${DEFAULT_MODE})"
    echo "  -i    IPSW file path (default: ${DEFAULT_IPSW_FILE})"
    exit 1
}

########## Parse Command Line Options ##########
while getopts "p:m:i:h" opt; do
    case "$opt" in
        p) macVMPath="$OPTARG" ;;
        m) mode="$OPTARG" ;;
        i) ipsw_file_name="$OPTARG" ;;
        h|\?) usage ;;
    esac
done

# Set defaults if variables are not provided by the user
macVMPath=${macVMPath:-"$DEFAULT_MAC_VDM_PATH"}
mode=${mode:-"$DEFAULT_MODE"}
ipsw_file_name=${ipsw_file_name:-"$DEFAULT_IPSW_FILE"}

########## Check for Root ##########
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script should be run as root"
    exit 1
fi

########## Main Function ##########
main(){
    if ! command -v cfgutil >/dev/null 2>&1; then
        echo "❌ cfgutil does not exist. Please open Apple Configurator Menu > Install Automation Tool"
        exit 1
    else
        echo "✅ cfgutil exists..."
    fi

    if [[ -d "$macVMPath" ]]; then
        echo "✅ Folder path exists: $macVMPath"
        cd "$macVMPath" || { echo "Failed to change directory to $macVMPath"; exit 1; }
        ./macvdmtool "$mode"
        sleep 4
        # Confirm device attached
        attached_count=$(cfgutil list-devices | wc -l | awk '{print $NF}')
        if [ "$attached_count" -gt 0 ]; then
            echo "✅ Attached device found. Copying IPSW..."
            cfgutil -v restore -I "$ipsw_file_name"
        else
            echo "❌ No attached device found"
        fi
    else
        echo "❌ macvdmtool folder not found at $macVMPath"
        exit 1
    fi
}

main
