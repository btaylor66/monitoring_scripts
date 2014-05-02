#!/bin/bash
date=`date +%d%b%Y`
total=`grep NX_ERR_ORDER_NOT_A_WORKING_ORDER /var/stellar/log/$date/OrderServer* | grep ApplyOrderPullConfirmation | wc -l`
lasthour=`grep NX_ERR_ORDER_NOT_A_WORKING_ORDER /var/stellar/log/$date/OrderServer* | grep ApplyOrderPullConfirmation | grep  "$(date +'%d%b%y %H' -d '1 hour ago')" | wc -l`
alarmtype=2
if [ $lasthour -eq 0 ]; then
        severity="clear"
        alarmtype=300
fi
if [ $lasthour -gt 1 ]; then
        severity="warning"
fi
if [ $lasthour -gt 10 ]; then
        severity="minor"
fi
if [ $lasthour -gt 50 ]; then
        severity="major"
fi
if [ $lasthour -gt 500 ]; then
        severity="critical"
fi
message="Stellar rejected pulls count $lasthour in the last hour ($total for the day) Run from ${0}"
echo $message
curl -d "summary=$message&alarm_group=Stellar&subalarm_group=Rejected Pulls&severity=$severity&alarm_type=$alarmtype" http://ch11lxmon02:8000/alert
