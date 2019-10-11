#! /bin/bash

# TODO (vkhitrin): Consider using a generic logic for write and delete

ACTION=$1
if [[ $ACTION == 'install' ]];then
    echo "Writing macOS defaults"
    defaults write com.apple.screencapture disable-shadow -bool true
    defaults write com.apple.finder AppleShowAllFiles TRUE
    echo "Restarting Finder"
    killall Finder
    echo "Writing itsycal defaults"
    defaults write com.mowglii.ItsycalApp ClockFormat 'EEEE, d MMMM, HH:mm:ss'
    defaults write com.mowglii.ItsycalApp HideIcon 1
    defaults write com.mowglii.ItsycalApp HighlightedDOWs 96
    defaults write com.mowglii.ItsycalApp ShowEventDays 7
    defaults write com.mowglii.ItsycalApp ShowLocation 1
    defaults write com.mowglii.ItsycalApp ShowWeeks 1
    defaults write com.mowglii.ItsycalApp SizePreference 1
elif [[ $ACTION == 'uninstall' ]]; then
    echo "Deleting macOS defaults"
    defaults delete com.apple.screencapture disable-shadow
    defaults delete com.apple.finder AppleShowAllFiles
    echo "Restarting Finder"
    killall Finder
    echo "Deleting itsycal defaults"
    defaults delete com.mowglii.ItsycalApp ClockFormat
    defaults delete com.mowglii.ItsycalApp HideIcon
    defaults delete com.mowglii.ItsycalApp HighlightedDOWs
    defaults delete com.mowglii.ItsycalApp ShowEventDays
    defaults delete com.mowglii.ItsycalApp ShowLocation
    defaults delete com.mowglii.ItsycalApp ShowWeeks
    defaults delete com.mowglii.ItsycalApp SizePreference
else
    echo "Accepted arguments: 'install', 'uninstall'"
fi
