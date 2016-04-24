#!/bin/bash

# Script to create regions
# more descriptions here

source config/reg.cfg
UUID=$(uuidgen)
RegionName=$2
RegionNameFileSys=${RegionName,,}
Port=$3
Coordinates=$4

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

		case $1 in

			list)
				ls -al $OpenSim_Land
				echo "NOTE: it will be tested whether a Region exists or not"
			;;

			create)
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
						mkdir $OpenSim_Land/$RegionNameFileSys
						mkdir  $OpenSim_Land/$RegionNameFileSys/Regions
						touch  $OpenSim_Land/$RegionNameFileSys/OpenSim.ini
						
echo "[Startup]
PIDFile = $OpenSim_Pid
regionload_regionsdir =  $OpenSim_Land/$RegionNameFileSys/Regions/
Stats_URI = "jsonSimStats"

[Network]
http_listener_port = $3" >> $OpenSim_Land/$RegionNameFileSys/OpenSim.ini

touch  $OpenSim_Land/$RegionNameFileSys/OpenSim.exe.config

echo "<?xml version="1.0" encoding="utf-8" ?>
<configuration>
  <configSections>
    <section name="log4net" type="log4net.Config.Log4NetConfigurationSectionHandler,log4net" />
  </configSections>
  <runtime>
    <gcConcurrent enabled="true" />
        <gcServer enabled="true" />
  </runtime>
  <appSettings>
  </appSettings>
  <log4net>
    <appender name="Console" type="OpenSim.Framework.Console.OpenSimAppender, OpenSim.Framework.Console">
      <layout type="log4net.Layout.PatternLayout">
        <conversionPattern value="%date{HH:mm:ss} - %message" />
        <!-- console log with milliseconds.  Useful for debugging -->
<!--        <conversionPattern value="%date{HH:mm:ss.fff} - %message" /> -->
      </layout>
    </appender>

<appender name="RollingFileAppender" type="log4net.Appender.RollingFileAppender">
  <file value=$OpenSim_Log/$RegionName.log />
  <appendToFile value="true" />
  <maximumFileSize value="1000KB" />
  <maxSizeRollBackups value="2" />
  <layout type="log4net.Layout.PatternLayout">
    <conversionPattern value="%date %-5level - %logger %message%newline" />
  </layout>
</appender>

    <root>
      <level value="DEBUG" />
      <appender-ref ref="Console" />
      <appender-ref ref="RollingFileAppender" />
    </root>

    <!-- Independently control logging level for XEngine -->
    <logger name="OpenSim.Region.ScriptEngine.XEngine">
      <level value="INFO"/>
    </logger>

    <!-- Independently control logging level for per region module loading -->
    <logger name="OpenSim.ApplicationPlugins.RegionModulesController.RegionModulesControllerPlugin">
      <level value="INFO"/>
    </logger>

  </log4net>
</configuration>" >> $OpenSim_Land/$RegionNameFileSys/OpenSim.exe.config

touch  $OpenSim_Land/$RegionNameFileSys/Regions/Regions.ini

echo "[$RehionName]
RegionUUID = $UUID
Location = $4
InternalAddress = 0.0.0.0
InternalPort = $3
AllowAlternatePorts = False
ExternalHostName = SYSTEMIP
RegionType = "Mainland"
MaxPrims = 45000
MaxAgents = 40" >> $OpenSim_Land/$RegionNameFileSys/Regions/Regions.ini

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

			*)
		esac