#!/bin/bash

# Script to create regions
# more descriptions here

source config/reg.cfg
UUID=$(uuidgen)
RegionName=$2
RegionNameLower="$RegionName" | tr '[:upper:]' '[:lower:]'
Port=$3

clear

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
echo "Directory to be created in $OpenSim_Land: $RegionNameLower"

case $1 in

	list)
	ls -al $OpenSim_Land
	
	echo "NOTE: it will be tested whether a Region exists or not"
	;;
	create)
	if [ -d $OpenSim_Land/$RegionNameLower ] ; then 
 		echo ""
		echo "verzeichnis vorhanden"
 	else
 		mkdir $OpenSim_Land/$RegionNameLower
 	fi
	
	
	;;
	delete)
	;;
	config)
	;;

*)
esac
