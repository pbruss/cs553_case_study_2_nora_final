#!/bin/bash
# DS/CS533 Case Study 2
# Extra Credit: A script that is called when recovery.sh detects that the virtual machine for group 14 has been

# Calling connect_student_admin.sh
echo "Running connect_student_admin.sh..."
./connect_student_admin.sh
if [ $? -ne 0 ]; then
  echo "connect_student_admin.sh failed. Exiting."
  exit 1
fi

# Calling setup_vm.sh to setup remote virtual machine
echo "Running setup_vm.sh..."
./setup_vm.sh
if [ $? -ne 0 ]; then
  echo "setup_vm.sh failed. Exiting."
  exit 1
fi

# Calling connect.sh to SSH into the remote server
echo "Running connect.sh..."
./connect.sh
if [ $? -ne 0 ]; then
  echo "connect.sh failed. Exiting."
  exit 1
fi

# Calling deploy.sh to re-deploy NORA
echo "Running deploy.sh..."
./deploy.sh
if [ $? -ne 0 ]; then
  echo "deploy.sh failed. Exiting."
  exit 1
fi

echo "All scripts completed successfully."
