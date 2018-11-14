#!/bin/bash
###############################################################################
# This is a script to automatically update Ubuntu system/server
###############################################################################


### Varibles
upToDate="All packages are up to date."
logName="check-update.txt"

echo "$upToDate"

### Functions
divider() {
  echo -e "\n================================================================\n"
}

## Function to remove check-update.txt file
removeLog() {
  rm $logName
}


## Function to refresh repo database
refreshDB() {
  echo "Refreshing repository database..."
  sleep 2
  apt update | tee $logName
  divider
}


## Function to check if the system needs to be updated or if should be.
checkUpdate() {
  # Store string from file into var 'upgrades'
  upgrades=`cat $logName | grep -ow "$upToDate"`

  if [ "$upgrades" == "$upToDate" ]
  then
    echo "Upgrading system..."
    apt upgrade -y
    divider

    echo "Removing unnecesary dependencies..."
    apt autoremove -y
    divider

    echo -e 'Rebooting system...'
    divider

    removeLog
    reboot

  else
    removeLog
    echo "No updates available."
    divider
  fi
}


## Functions to initialize commands if the user is root
update() {
  if [ $USER == "root" ]
  then
    refreshDB
    checkUpdate
  else
    echo 'You need to be root to run this command...'
  fi
}

update
