#!/bin/bash

#######################################################################
# Title      :    omi.sh
# Author     :    Markus Metzmacher {info@3dgrid.de}
# Date       :    18.06.2016
# Requires   :    dialog
# Category   :    OpenSimulator Management Interface
#######################################################################
# Description
#   Provides a Shell Interface to manage OpenSimulator Tasks
#   create, delete and maintain OpenSimulator Regions
#   add OAR Backup, file backup db backub and monitoring functionality
#######################################################################

source config/reg.cfg

_temp="/tmp/answer.$$"
PN=`basename "$0"`
VER='0.01'
dialog 2>$_temp
DVER=`cat $_temp | head -1`

### shows program version 
version() {
    dialog --backtitle "OMI program version" \
           --msgbox "$PN - Version $VER\nOpenSimulator Management Interface\nProgrammed by Markus Metzmacher\nJune 2016\n\nusing:\n$DVER" 15 52
}

edit() {
    filename="config/reg.cfg"
    filenameTMP=$filename.tmp
    if [ -e $filename ]; then
        cp $filename $filenameTMP
        dialog --backtitle "Edit configuration file - use [up] [down] to scroll"\
               --begin 3 5 --title " viewing File: $filenameTMP "\
               --stdout --editbox $filenameTMP 22 80 > $filename
        rm $filenameTMP
#        $editor $filename
    else
        dialog --msgbox "*** ERROR ***\n$filename does not exist" 6 42
    fi
}

main_menu() {
    dialog --backtitle "OpenSimulator Management Interface" --title " Main Menu - V. $VER "\
        --cancel-label "Quit" \
        --menu "Move using [UP] [DOWN], [Enter] to select" 20 80 13\
        EditConfig "Edit configuration for your OpenSimulator Setup"\
        New "Create new Region "\
        Delete "Delete a Region"\
        AddOAR "Add OAR Backup for a certain Region"\
        AddMonit "Add monitoring for a certain Region"\
        AddFile "Add file backup for the whole setup"\
        AddDB "Add database backup for you Regions DB"\
        Gauge "Progress bar"\
        OpenReg "Switch to a regions console"\
        DisableMonit "Disable monitoring for an existing region"\
        EnableMonit "Enable monitoring for an existing region"\
        TailRegLog "Show a log file for a running region"\
        Version "Show program version info"\
        Quit "Exit OpenSimulator Management Interface" 2>$_temp
        
            
    opt=${?}
    if [ $opt != 0 ]; then rm $_temp; exit; fi
    menuitem=`cat $_temp`
    echo "menu=$menuitem"
    case $menuitem in
        EditConfig) edit;;
        Gauge) gauge;;
        File) file_select;;
        Home_Menu) file_menu;;
        Input) inputbox;;
        Calendar) calendar;;
        Editor) vi test.txt;;
        Multi) checklist;;
        Radio) radiolist;;
        Show) textbox;;
        Tail) tailbox;;
        Version) version;;
        Form) formbox;;
        Quit) rm $_temp; exit;;
    esac
}

while true; do
  main_menu
done