#!/bin/bash
# A script that monitors the uptime situation of the virtual machine hosting NORA
# Configuration
PORT=22014
MACHINE="paffenroth-23.dyn.wpi.edu"
CHECK_INTERVAL=5 # in minutes
LOG_FILE="vm_check.log"

# Function to check if the VM is up
check_vm_status() {
  nc -z -w5 $MACHINE $PORT
  return $?
}

# Main loop to check the status periodically
while true; do
  TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
  if check_vm_status; then
    echo "$TIMESTAMP: VM is up." >> $LOG_FILE
  else
    echo "$TIMESTAMP: VM is down. Triggering recovery." >> $LOG_FILE
    ./vm_recovery.sh
  fi

  # Sleep for the specified interval before checking again
  sleep $((CHECK_INTERVAL * 60))
done
