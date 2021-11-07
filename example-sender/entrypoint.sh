#!/bin/bash


# Timeout=0 --> timeout disabled
/wait-for-it.sh --timeout=0 mailserver:587 -- echo "mailserver is up"

while true
do
   echo "Try to send a new message." 
   MESSAGE="It's $(date +%T) and all's well..."
   echo ${MESSAGE} | mailx -v -s "${MESSAGE}" user@example.com
   sleep 30
done

