#!/bin/bash
# Developed by Markus Metzmacher | 3DGrid
# 04/05 2016
# Version: V1.1 (Enhanced)
# Source on git@bitbucket.org:mmetzmac/opensim-region-tools.git
# Ask info@3dgrid.de to get involved
# tested on CentOs 7.2 and Ubuntu 18.04

# Script to maintain OpenSimulator regions
# Features:
# creates the region folder, OpenSim.ini, OpenSim.exe.config, Regions.ini
# inserts port and coordinate information by use of wight- and blacklist
# automatically assignes an UUID to a new region
# allows to activate OAR backup automatically
# allows the creation of monit monitoring parameter

# ToDo
# enhance with delete region and deactivate region functionallity
# enable the possibillity running with Linux dialog


# read the configuration file
# use reg.cfg for production environment
# or reg_test.cfg for test environment

source config/reg_test.cfg # currently setup for test environment!
                           # set to reg.cfg for usage in production environment
# add some more needed variables
Date=`date +"%d.%m.%Y - %H:%M"`
UUID=$(uuidgen)
RegionName=$2
RegionNameFileSys=${RegionName,,}

# export needed variables for use by the sub programs
export RegionName
export RegionNameFileSys
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

# Specify the Port (UDP and TCP on one and the same Port
clear
echo "**************************************************************"
echo "***                                                        ***"
echo "***     now asking son questions and doing some checks     ***"
echo "***                                                        ***"
echo "**************************************************************"

read -p "Please input the Port to be uses (i.E.: 9000): " Port
if grep $Port data/ports.dta > /dev/null
then
	echo ""
	echo "Port already in use. ABORTING"
	exit
else
	echo ""
	echo "Will use Port $Port for region $RegionName"
	export Port
fi

# Specify the region coordinates in the grid
read -p "Please input the coordinates to be used (i.E. 4000,4000): " Coordinates
if grep $Coordinates data/coordinates.dta > /dev/null
then
	echo ""
        echo "Coordinates already in use. ABORTING"
        exit
else
        echo ""
	echo "Now checking if the coordinates are in the list provided by the Grid owner (allowed coordinates)"

	# Read the whitelist for valid coordinates
	if grep $Coordinates data/allowed_coordinates.dta > /dev/null
	then
		echo ""
		echo "Coordinates are in the whitelist. Will use $Coordinates for region $RegionName."
		export Coordinates
	else
		echo ""
		echo "Coordinates are not allowed by the Grid owner!"
		echo "please add coordinates to data/allowed_coordinates.dta or"
		echo "if you are not the grid admin, ask the owner of the grid to"
		echo "provide a file with valid coordinates"
		echo ""
		echo "ABORTING"
		exit
	fi
fi

echo ""
echo "************************************************************"
echo "***                     REGION CREATOR                   ***"
echo "************************************************************"
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
        echo "NOTE: if you have enabled monitoring, the region will atart"
	echo "automatically if you restart the monit service. Otherwise start"
	echo "the new region with the command ./os.sh start <RegionName>"

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
echo "$Coordinates" >> data/coordinates.dta
echo "$Port" >> data/ports.dta
echo "$RegionName" >> data/land.dta
echo "$Date: $RegionName $RegionNameFileSys $Coordinates $Port" >> data/regioninfo.dta
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
echo -e "\e[33m************************************************************"
echo "***********         OpenSim TOOLS - HELP         ***********"
echo "************************************************************"
echo -e "\e[32m"
echo "use: ./cr.sh <option> <regionname>"
echo ""
echo "EXAMPLE: ./cr.sh create Semester-1-2016-1"
echo ""
echo "There are following options:"
echo ""
echo -e "\e[33m 1: create - creates a new region"
echo " 3: delete - deletes an existing Region"
echo " 4: list - lists all regions currently available"
echo " 5: monit_on - enables monitoring for a certain Region"
echo " 6: monit_off - disbles monitoring for a certain Region"
echo " 7: backup_on - enables backup for a certain Region"
echo " 8: backup_off - disables backup for a certain Region"
echo " 9: status - shows currently running Regions with their parameters"
echo "10: help - shows this dialog"
echo ""
echo -e "\e[31mNOTE: before you use the system, ensure, that you have set your"
echo "      local OpenSim environment variables in file config/reg.cnf"
echo ""
echo "      Always read the README file to have the latest news!"

;;

*)
esac
