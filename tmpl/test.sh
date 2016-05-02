#!/bin/bash

touch test.txt

echo "check process $RegionName with pidfile $OpenSim_Pid/$RegionNameFileSys.pid
    start program = \"$Tools_Path/./os start $RegionNameFileSys\"
	as uid $OpenSim_User and gid $OpenSim_User
    stop program = \"$Tools_Path/./os stop $RegionNameFileSys\"
    if cpu usage > 1200% for 4 cycles then restart
    if 5 restarts within 5 cycles then timeout
    if failed url http://localhost:$Port/jsonSimStats/
        and content != '\"SimFPS\":0.0,' for 4 cycles
        then restart
    if failed url http://localhost:$Port/jsonSimStats/
        and content == '\"SimFPS\":' for 4 cycles
        then restart
    group opensim" >> test.txt
