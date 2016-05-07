#!/bin/bash

# Script to create regions
# more descriptions here

# read the configuration file
source config/reg.cfg

# add some more needed variables
Date=`date +"%d.%m.%Y - %H:%M"`
UUID=$(uuidgen)
RegionName=$2
RegionNameFileSys=${RegionName,,}
Port=$3
Coordinates=$4

#export needed variables for use by the sub programs
export RegionName
export RegionNameFileSys
export Port
export Coordinates
export UUID
export OpenSim_Pid
export OpenSim_Land
export OpenSim_Log
export OpenSim_Oar
export Monit_Conf
export Monit_In_Active
export OAR_Dir
export Tools_Path
export OpenSim_User

# clear the screen
clear

# read options
case $1 in

# list all regions available right now
list)
	ls -al $OpenSim_Land
	echo "NOTE: it will be tested whether a Region exists or not"
	;;

# create new region with all needed files and entries in monitoring setup
create)

echo ""
echo "**********************************************"
echo "***********     REGION CREATOR     ***********"
echo "**********************************************"
echo ""
echo "The new Regioon will be named: $RegionName"
echo ""
echo "Path for OpenSim base directory: $OpenSim_Base"
echo "Path for OpenSim Land directory: $OpenSim_Land"
echo "Path for OpenSim OAR directory: $OpenSim_Oar"
echo "Path for OpenSim PID directory: $OpenSim_Pid"
echo "Path for OpenSim LOG directory: $OpenSim_Log"
echo "Path for OpenSim DB directory: $OpenSim_Db"
echo""
echo "The following UUID will be used for the new Region: $UUID"
echo "The following port will be used: $Port"
echo "The following coordinates will be used: $Coordinates"
echo ""
echo "Directory to be created in $OpenSim_Land: $RegionNameFileSys"
echo "Region in Simulation will be named: $RegionName"
echo ""
echo "Lofiles will be stored in $OpenSim_Log as $RegionName.log"
echo ""

read -p "Create new Region (y/n)? " response

if [ "$response" == "y" ]; then

if [ -d $OpenSim_Land/$RegionNameFileSys ] ; then
	echo ""
	echo "Directory existing - will abort the operation"
        echo ""
	echo "PLEASE CHOOSE A REGION NAME, THAT DOES NOR EXIST ON THIS SERVER"
        echo ""
	exit
else
	echo ""
        echo "$OpenSim_Land/$RegionNameFileSys will be created in $OpenSim_Land"
        echo "Region will be found by searching $RegionName in Opensimulatior Viewer"
        echo "Please remember to add the Name $RegionNameFileSys to the instances section of"
	echo "/home/opensim/bin/os scripts"
	echo ""

# create the directories and touch the necessary files
mkdir $OpenSim_Land/$RegionNameFileSys
mkdir $OpenSim_Land/$RegionNameFileSys/Regions
touch $OpenSim_Land/$RegionNameFileSys/OpenSim.ini
touch $OpenSim_Land/$RegionNameFileSys/OpenSim.exe.config
touch $OpenSim_Land/$RegionNameFileSys/Regions/Regions.ini

# fill the files used by OpenSim.exe
tmpl/./opensim.ini.tmpl
tmpl/./opensim.exe.config.tmpl
tmpl/./regions.ini.tmpl

# ask, if monit is installed and whether it should be activated for the new region or not
read -p "Would you like the new Region to be added to the monitoring system (y/n)? " response
if [ "$response" == "y" ]; then
	tmpl/./add_region_monitoring.tmpl

        echo ""
        echo "Monitoring installed!"
        echo ""
	echo "Please use systemctl restart monit.service to let new setings become active"
        echo "*************************************************************************************"
	echo "***  NOTE: this will restart all regions currently monitored and will though out  ***"
	echo "***  potential visitors/avatars                                                   ***"
        echo "*************************************************************************************"
	echo ""

else
	echo ""
	echo "Monitoring NOT installed!"
	echo ""
fi

# ask, if OAR backup should be activated for the new region
read -p "Shall the system automatically create OAR backups (y/n)? " response
if [ "$response" == "y" ]; then
        tmpl/./add_oar_backup.tmpl
else
        echo "Backup not activated!"
fi

# store parameter into corresponding files
echo "$Coordinates" >> data/coordinates.txt
echo "$Port" >> data/ports.txt
echo "$RegionName" >> data/land.txt
echo "$Date: $RegionName $RegionNameFileSys $Coordinates $Port" >> data/regioninfo.txt
echo "$RegionNameFileSys" >> data/regions.dta

# unset all variables
unset RegionName
unset RegionNameFileSys
unset Port
unset Coordinates
unset UUID
unset OpenSim_Pid
unset Opensim_Land
unset OpenSim_Log
unset OpenSim_Oar
unset Monit_Conf
unset Monit_In_Active
unset OAR_Dir
unset Tools_Path
unset OpenSim_User

fi
else
	echo "ABORTING"
	exit
fi
;;

delete)
;;

config)
;;

help)
clear
echo "************************************************************"
echo "***********         OpenSim TOOLS - HELP         ***********"
echo "************************************************************"
echo ""
echo "use: ./cr.sh <option> <regionname> <port> <coordinates>"
echo ""
echo "EXAMPLE: ./cr.sh create Semester-1-2016-1 19060 7200,7200"
echo ""
echo "there are following options:"
echo "1: create - creates a new region"
echo "2: list - lists all regions currently available"
echo "3: help - shows this dialog"
echo ""
echo "NOTE: before you use the system, ensure, that you have set your"
echo "local OpenSim environment variables in file config/reg.cnf"
echo ""
echo "Always red the README file to have the latest news!"

;;

*)
esac
