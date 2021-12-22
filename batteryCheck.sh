#!/bin/bash
################################################################################
#	Battery checker utility
################################################################################
#	Author:
#		Luca Lombardini
#	Contacts:
#		s277972@studenti.polito.it
#		lombamari2@gmail.com
################################################################################
#	Purpose:
#		Check the various available info for the PC's batteries 
#		(Status, Capacity, Voltage, Charge status, Alarms)
################################################################################
#	Year:	2019-2021
################################################################################
#	License: GPL-2.0
################################################################################

CAP_INI=0
CAP_INI_DEC=0
CAP_INI_INT=0
CAP_ACT=0
CAP_ACT_DEC=0
CAP_ACT_INT=0

function padder {
	[[ ${#1} -eq 1 ]] && echo "0$1" || echo "$1"
}

for battery in $(ls /sys/class/power_supply | grep BAT); do
	echo -e "Battery: $battery"
	echo -e "\tAlarm code (0: no critical issues): $(cat /sys/class/power_supply/$battery/alarm)"
	echo -e "\tCapacity level (should be [Normal]): $(cat /sys/class/power_supply/$battery/capacity_level)"	
	CAP_INI=$(cat /sys/class/power_supply/$battery/energy_full_design) #uW
	CAP_INI_INT=$((CAP_INI/1000000))
	CAP_INI_DEC=$((CAP_INI/1000 - 1000*CAP_INI_INT))
	echo -e "\tDesigned energy capacity: $CAP_INI_INT.$CAP_INI_DEC Wh"
	CAP_ACT=$(cat /sys/class/power_supply/$battery/energy_full)
	CAP_ACT_INT=$((CAP_ACT/1000000))
	CAP_ACT_DEC=$((CAP_ACT/1000 - 1000*CAP_ACT_INT))
	echo -e "\tResidual energy capacity: $CAP_ACT_INT.$CAP_ACT_DEC Wh"
	RES_CAP=$((CAP_ACT*10000/CAP_INI))
	RES_CAP_INT=$((RES_CAP/100))
	RES_CAP_DEC=$((RES_CAP - 100*RES_CAP_INT))
	echo -e "\tRelative energy capacity: $RES_CAP_INT.$(padder $RES_CAP_DEC) %"
	LOSS_CAP=$((10000 - RES_CAP))
	LOSS_CAP_INT=$((LOSS_CAP/100))
	LOSS_CAP_DEC=$((LOSS_CAP - 100*LOSS_CAP_INT))
	echo -e "\tRelative capacity lost: $LOSS_CAP_INT.$(padder $LOSS_CAP_DEC) %"
	EN_NOW=$(cat /sys/class/power_supply/BAT0/energy_now)
	EN_NOW_INT=$((EN_NOW/1000000))
	EN_NOW_DEC=$((EN_NOW/1000 - 1000*EN_NOW_INT))
	echo -e "\tReal-time stored energy: $EN_NOW_INT.$EN_NOW_DEC Wh"
	echo -e "\tActual percentage: $(cat /sys/class/power_supply/BAT0/capacity)"
	echo -e "\tBattery status: $(cat /sys/class/power_supply/$battery/status)"
	echo -e "\tBattery technology: $(cat /sys/class/power_supply/$battery/technology)"
	echo -e "\tMinimum design voltage: $(awk '{print $1*10^-6 " V"}' /sys/class/power_supply/$battery/voltage_min_design)"
	echo -e "\tReal-time voltage: $(awk '{print $1*10^-6 " V"}' /sys/class/power_supply/$battery/voltage_now)"
done
