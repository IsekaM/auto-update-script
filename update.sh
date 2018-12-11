#!/bin/bash
###############################################################################
# This is a script to automatically update Ubuntu system/server
###############################################################################


### Varibles
upToDate="`cat /var/lib/update-notifier/updates-available | grep -ow '0 packages can be updated'`"
rebootRequired="/var/run/reboot-required"


### Functions

## Function to: echo a 'divider'
divider() {
  echo -e "\n================================================================\n"
}


## Function to: Echo Text
echoE() {
  echo -e "$1"
}


## Function to: Echo text with dividers
echoD() {
  divider
  echoE "$1"
  divider
  sleep 2
}


## Function to: Update package repo
checkSys() {
  echoD "Updating Package Repository"
  apt update
}


## Function to: Update system if it needs to be updated
upgradeSys() {
  if [ -z "$upToDate" ]
  then
    echoD "Upgrading Packages"
    apt upgrade -y
    echoD "Removing Outdated/Unnecesarry Dependecies"
    apt autoremove -y
  else
    echoD "No Upgrades available"
  fi
}


## Function to: Check if the system needs to be rebooted
checkReboot() {
  if [ -f $rebootRequired ]
  then
    echoD "System Reboot Is Required"
    reboot
  fi
}


## Function to: Initialize Script
init() {
  if [ $USER == "root" ]
  then
    checkSys
    upgradeSys
    checkReboot
  else
    echoE "You need to be root to run this command"
  fi
}

init
