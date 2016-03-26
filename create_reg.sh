#!/bin/bash

# Script to create regions
# more descriptions here

source config/reg.cfg
UUID=$(uuidgen)
RegionName=$2
RegionNameFileSys=${RegionName,,}
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
echo ""
echo "Directory to be created in $OpenSim_Land: $RegionNameFileSys"
echo "Region in Simulation will be named: $RegionName"
echo ""

read -p "Übernehmen (j/n)? " response

if [ "$response" == "j" ]; then

        if [ -d $OpenSim_Land/$RegionNameFileSys ] ; then
                echo ""
                echo "Directory existing - will abort the operation"
		echo ""
                echo "PLEASE CHOOSE A REGION NAME, WICH DOES NOR EXIST ON THIS SERVER"
		echo ""
		exit
        else
                echo""
		echo "$OpenSim_Land/$RegionNameFileSys will be created in $OpenSim_Land"
		echo "Region will be found by searching $RegionName in Opensimulatior Viewer"
		echo""
	
case $1 in

	list)
	ls -al $OpenSim_Land
	echo "NOTE: it will be tested whether a Region exists or not"
	;;

	create)
	mkdir $OpenSim_Land/$RegionNameFileSys
	;;

	delete)
	;;

	config)
	;;

*)
esac
fi
fi
