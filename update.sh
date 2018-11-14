#!/usr/bin/env bash

#This is a script to automatically update Ubuntu system/server

divider() {
  echo -e "\n================================================================\n"
}

refreshDB() {
  echo "Refreshing repository database..."
  sleep 2
  apt update
  divider
}

checkUpdate() {
  upgrades="$(refreshDB | grep -ow 'All packages are up to date.')"
  echo $upgrades

  if [[ ! -z "$upgrades" ]]
  then
    echo "Upgrading system..."
    apt upgrade -y
    divider

    echo "Removing unnecesary dependencies..."
    apt autoremove -y
    divider

    echo -e 'Rebooting system...'
    divider
    reboot

  else
    echo "No updates available."
  fi
}

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
