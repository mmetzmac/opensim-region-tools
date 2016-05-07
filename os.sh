#!/bin/bash
#
# for usage, run without arguments
#
# see ../README for setup instructions.
#
 
# Original code by Dave Coyle (http://coyled.com)
# Tweaks by Gwyneth Llewelyn (http://gwynethllewelyn.net/)
#
# Again tweaked by Markus Metzmacher (http://www.3dgrid.de) 
# Requires bash 4
 
# The original script assumed that you‘d be running one sim per instance,
#  and launch a different script per sim.
# These changes assume you have multiple instances with multiple sims,
#  and that instance names are launched all from the same place with
#  an unique identification for each
 
# List of valid instances. Make sure you add all of your instances here

# the file data/regions.dta is automatically amended when a new region is created!
FILE=data/regions.dta
AvailableRegions=`cat $FILE`

declare -A instances
for index in $AvailableRegions
do
        instances[$index]=1
done
 
show_help() {
    echo "Input: opensim {start|stop|open|restart|console} "
    echo -n "    for following Regions: "
    echo ${!instances[*]}
}
 
# Change <opensim_user> with your valid opensim user
check_user() {
    if [ $USER != 'opensim' ]; then
        echo "Only opensim is allowed to use the script"
        exit 1
    fi
}
 
setup() {
    if [ ! $1 ]; then
        show_help
        exit 1
    else
        SIM=$1
    fi
 
# Change the directories inline with your installation directories
# The pid_dir must be set to the value, you used in OpenSim.exe.config
# within your regions path
if [[ ${instances[$SIM]} ]]; then
        MONO="mono --optimize=sse2"
        OPENSIM_DIR="/home/opensim/simulation/083plus"
        PID="/home/opensim/simulation/pid/${SIM}.pid"
        SCREEN="screen"
        GRID_DIR="/home/opensim/simulation/land"
        # set GRID_DIR to the subdirectory where your individual
        #  instance configuration is
    else
        echo "Region ${SIM} is unknown. Exit."
        exit 1;
    fi
}
 
do_start() {
    if [ ! $1 ]; then
        show_help
        exit 1
    else
        SIM=$1
    fi
 
    setup $SIM
    check_user
 
    cd ${OPENSIM_DIR}/bin && $SCREEN -S $SIM -d -m -l $MONO OpenSim.exe -hypergrid=true -inidirectory="$GRID_DIR/$SIM" -logconfig="$GRID_DIR/$SIM/OpenSim.exe.config"
}
 
do_kill() {
    if [ ! $1 ]; then
        show_help
        exit 1
    else
        SIM=$1
    fi
 
    setup $SIM
    check_user
 
    if [ -f $PID ]; then
        kill -9 `cat $PID`
    else
        echo "Region ${SIM} PID not found."
        exit 1
    fi
}
 
do_console() {
    if [ ! $1 ]; then
        show_help
        exit 1
    fi
 
    setup $1
 
    cd ${OPENSIM_DIR}/bin && $SCREEN -S $SIM -d -m -l $MONO OpenSim.exe -hypergrid=true -inidirectory="$GRID_DIR/$SIM" -logconfig="$GRID_DIR/$SIM/OpenSim.exe.config"
}
 
do_open() {
if [ ! $1 ]; then
        show_help
        exit 1
    else
        SIM=$1
    fi
 
    setup $SIM
    check_user
 
    if [ -f $PID ]; then
        screen -r $SIM
    else
        echo "Region ${SIM} PID not found."
        exit 1
    fi
}
 
case "$1" in
    start)
        do_start $2
        ;;
    stop)
        do_kill $2
        ;;
    open)
    do_open $2
;;
    kill)
        do_kill $2
        ;;
    restart)
        do_kill $2
        do_start $2
        ;;
    console)
        do_console $2
        ;;
    *)
        show_help
        exit
        ;;
    esac
