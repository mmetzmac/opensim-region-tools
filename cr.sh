#!/bin/bash

# Script to create regions
# more descriptions here

source config/reg.cfg
Date=`date +"%d.%m.%Y - %h:%m"`
UUID=$(uuidgen)
RegionName=$2
RegionNameFileSys=${RegionName,,}
Port=$3
Coordinates=$4

export RegionName
export RegionNameFileSys
export Port
export Coordinates
export UUID
export OpenSim_Pid
export OpenSim_Land
export OpenSim_Log

clear

		case $1 in

			list)
				ls -al $OpenSim_Land
				echo "NOTE: it will be tested whether a Region exists or not"
			;;

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
				read -p "Übernehmen (j/n)? " response

				if [ "$response" == "j" ]; then

        			if [ -d $OpenSim_Land/$RegionNameFileSys ] ; then
                		echo ""
                		echo "Directory existing - will abort the operation"
                        echo ""
                		echo "PLEASE CHOOSE A REGION NAME, THAT DOES NOR EXIST ON THIS SERVER"
                        echo ""
                		exit
        			else
                		echo""
                        echo "$OpenSim_Land/$RegionNameFileSys will be created in $OpenSim_Land"
                        echo "Region will be found by searching $RegionName in Opensimulatior Viewer"
                        echo "Please remember to add the Name $RegionNameFileSys to the instances section of"
			echo "/home/opensim/bin/os scripts"
			echo""
mkdir $OpenSim_Land/$RegionNameFileSys
mkdir  $OpenSim_Land/$RegionNameFileSys/Regions
touch  $OpenSim_Land/$RegionNameFileSys/OpenSim.ini
touch  $OpenSim_Land/$RegionNameFileSys/OpenSim.exe.config
touch  $OpenSim_Land/$RegionNameFileSys/Regions/Regions.ini

tmpl/./opensim.ini.tmpl
tmpl/./opensim.exe.config.tmpl
tmpl/./regions.ini.tmpl

echo "$Coordinates" >> data/coordinates.txt
echo "$Port" >> data/ports.txt
echo "$RegionName" >> data/land.txt
echo "$Date: $RegionName $RegionNameFileSys $Coordinates $Port" >> data/regioninfo.txt

unset RegionName
unset RegionNameFileSys
unset Port
unset Coordinates
unset UUID
unset OpenSim_Pid
unset Opensim_Land
unset OpenSim_Log


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
			echo "use: ./cr.sh create regionname port coordinates"
			echo "EXAMPLE: ./cr.sh create Semester-1-2016-1 19060 7200,7200"
			;;

			*)
		esac
