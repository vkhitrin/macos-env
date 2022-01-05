#!/usr/bin/env bash

ACTION=$1
if [[ $ACTION == 'install' ]];then
	osascript -e "tell application \"System Events\" to set the autohide of the dock preferences to true"
elif [[ $ACTION == 'uninstall' ]]; then
	osascript -e "tell application \"System Events\" to set the autohide of the dock preferences to false"
else
    echo "Accepted arguments: 'install', 'uninstall'"
fi
