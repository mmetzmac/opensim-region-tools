#!/usr/bin/env bash

#export NEWT_COLORS='
#window=,red
#border=white,red
#textbox=white,red
#button=white,cyan
#listbox=white, cyan
#'



# check whether whiptail or dialog is installed
# (choosing the first command found)
read dialog <<< "$(which whiptail dialog 2> /dev/null)"

# exit if none found
[[ "$dialog" ]] || {
  echo 'neither whiptail nor dialog found' >&2
  exit 1
}

# just use whichever was found
"$dialog" --msgbox "Message displayed with $dialog" 0 0

t(){ type "$1"&>/dev/null;}
function Menu.Show {
   local DIA DIA_ESC; while :; do
      t whiptail && DIA=whiptail && break
      t dialog && DIA=dialog && DIA_ESC=-- && break
      exec date +s"No dialog program found"
   done; declare -A o="$1"; shift
   $DIA --backtitle "${o[backtitle]}" --title "${o[title]}" \
      --menu "${o[question]}" 0 0 0 $DIA_ESC "$@"; }



Menu.Show '([backtitle]="OpenSimulator Region Tools"
            [title]="Main Menu"
            [question]="Please choose:")'          \
                                                   \
            "A" "Show running Regions"	\
            "B" "Show all Regions"		\
            "C" "Show free ports"		\
	    "D" "Show free coordinates"
