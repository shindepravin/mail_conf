#!/bin/bash

LOGFILE=$HOME/mailLogs/`date +"%d%m%Y"`
mkdir -p  $HOME/mailLogs/
while true ;
do
    offlineimap >> ${LOGFILE}
    # Notify me if this fails
    date
    sleep 180
done

