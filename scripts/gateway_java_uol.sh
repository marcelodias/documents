#!/bin/sh
#
#Script for Gateway APP
#
##########################

export PATH="/bin:/sbin:/usr/bin:/usr/sbin"

#====== Variable Begin ======#
# Local date and hour 
date=`date +%d/%m/%Y-%H:%M:%S`

# Format hour script
hour=`date +%H:%M`

# Final hour
finalhour="17:40"

#GATEWAY=`/home/cielo/TnkServerPg/ java -jar TnkServerPgV0.7.7.jar -p 2000 -c 10`

# Find process
PROCESS=`ps -e|grep -w gedit|awk '{print $4}'`

# Archive log
LOG=./gateway_java_uol.log

#======  Variable End  ======#

if [ "$PROCESS" != "gedit" -a "$hour" != "$finalhour" ]; then
    echo "$date: Process is not started, begin execution now." >> $LOG
    exec /usr/bin/gedit 
elif [ "$PROCESS" == "gedit" -a "$hour" == "$finalhour" ]; then
    echo "$date: $hour and $finalhour are equal, $PROCESS will finished." >> $LOG
    killall -9 gedit
elif [ "$PROCESS" == "gedit" -a "$hour" != "$finalhour" ]; then
    echo "$date: $PROCESS is in execution now: $hour". >> $LOG
else
    echo "$date: Execution is not allowed, try again 60 seconds after..." >> $LOG
fi
