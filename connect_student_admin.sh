#! /bin/bash
# A file used to perform SSH connections with the remote server before a private mykey has been generated. This script uses the private key provided directly via Canvas
PORT=22014
MACHINE=paffenroth-23.dyn.wpi.edu
STUDENT_ADMIN_KEY_PATH=/home/pbruss/NORA/keys/student-admin_key

ssh -i ${STUDENT_ADMIN_KEY_PATH} -p ${PORT} -o StrictHostKeyChecking=no student-admin@${MACHINE}
