#! /bin/bash
# CS/DS533 Case Study 2
# File that performs SSH connection with the remote virtual machine using the private generated with setup_vm.sh
PORT=22014
MACHINE=paffenroth-23.dyn.wpi.edu

ssh -i tmp/mykey -p ${PORT} -o StrictHostKeyChecking=no student-admin@${MACHINE}
