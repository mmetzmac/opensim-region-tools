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

edit_env() {
    filename="config/reg.cfg"
    if [ -e $filename ]; then
#        dialog --backtitle "Edit configuration file - use [up] [down] to scroll"\
#               --begin 3 5 --title " viewing File: $filename "\
#               --editbox $filename 22 80 2> {out}>&1
        $editor $filename
    else
        dialog --msgbox "*** ERROR ***\n$filename does not exist" 6 42
    fi
}

config_menu(){
 dialog --backtitle "OpenSimulator Management Interface" --title " Edit System configuration"\
        --cancel-label "Back" \
        --menu "Move using [UP] [DOWN], [Enter] to select" 20 80 13\
        Environment "Edit configuration for your OpenSimulator Setup"\
        ShowEnvironment "Create new Region "\
        Back "go to main menu"  2>$_temp_config
        opt2=${?}

    if [ $opt2 != 0 ]; then rm $_temp_config; exit; fi
    menuitem_config=`cat $_temp_config`
    echo "menu_config=$menuitem_config"
    case $menuitem_config in
        Environment) edit_env;;
        ShowEnvironment) show_env;;
        Back) rm $_temp_config; main_menu;;
    esac
}

main_menu() {
    dialog --backtitle "OpenSimulator Management Interface" --title " Main Menu - V. $VER "\
        --cancel-label "Quit" \
        --menu "Move using [UP] [DOWN], [Enter] to select" 20 80 13\
        Config "Edit configuration for your OpenSimulator Setup"\
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
        Config) config_menu;;
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