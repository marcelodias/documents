#!/bin/sh
for devfull in /dev/sd?; do
    dev=$(/bin/echo $devfull | /bin/sed 's/^\/dev\///')
    /usr/sbin/smartctl -n idle -a $devfull >/var/tmp/smart-$dev.TMP
    /bin/mv /var/tmp/smart-$dev.TMP /var/tmp/smart-$dev
done
