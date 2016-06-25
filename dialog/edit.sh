# Edit
source config/reg.cfg

_temp="/tmp/answer.$$"
PN=`basename "$0"`
VER='0.01'
dialog 2>$_temp_e
DVER=`cat $_temp_e | head -1`


config_menu(){
 dialog --backtitle "OpenSimulator Management Interface" --title " Edit System configuration"\
        --cancel-label "Back" \
        --menu "Move using [UP] [DOWN], [Enter] to select" 20 80 13\
        Environment "Edit configuration for your OpenSimulator Setup"\
        ShowEnvironment "Create new Region "\
        Back "go to main menu"  #2>$_temp_e
        # opt2=${?}

    if [ $opt2 != 0 ]; then rm $_temp_e; exit; fi
    menuitem_config=`cat $_temp_e`
    echo "menu_config=$menuitem_e"
    case $menuitem_config in
        Environment) edit_env;;
        ShowEnvironment) show_env;;
        Back) rm $_temp_e; exit;;
    esac
}

while true; do
  config_menu
done
