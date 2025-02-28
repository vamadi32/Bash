#!/usr/bin/env bash
###
#
#            Name:  ipsw_mac_reloader.sh
#     Description:  Restore MacBook/IOS/IPAD using IPSW
#         Created:  2025-01-23
#   Last Modified:  2025-01-23
#         Version:  0.1.0
#
# Copyright Victor Amadi
#
########## Variables ##########


# Please change macVMPath name
# This script depends on 
# Input application name macvdmtool and expects the repo to be in folder name 
# PrivateGitRepo in the useer home folder

macVMPath="$HOME/PrivateGitRepo/macvdmtool"
mode="dfu"
ipsw_file_name="$HOME/IPSWs/UniversalMac_15.3.1_24D70_Restore.ipsw"

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script should be run as root"
    exit 1
fi

########## Functions ##########
main(){
    cfgutil_command=$(which cfgutil)
    error_output=$?
    if [ $error_output -gt 0 ]; then
        echo "❌ cfgutil does not exist. Please open Apple Configurator Menu > 
        Install Automation Tool"
        exit 1
    else
        echo "✅ cfgutil exists..."
    fi
    if [[ -d "$macVMPath" ]]; then
        echo "✅ Folder path exist cdying..."
        cd "$macVMPath"
        ./macvdmtool "$mode"
        sleep 4
        # confirm defice attached
        attached_count=$($cfgutil_command list-devices | wc -l | awk '{print $NF}')
        if [ $attached_count -gt 0 ]; then
            # copy IPSW
            echo "✅ Attached device found. Copying"
            $cfgutil_command -v restore -I "$ipsw_file_name"
        else
            echo "❌ No attached device found"
        fi
    else
        echo "❌ MacVDM Folder not found found"
    fi
}

main



