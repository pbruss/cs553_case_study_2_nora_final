#! /bin/bash

PORT=22014
MACHINE=paffenroth-23.dyn.wpi.edu
STUDENT_ADMIN_KEY_PATH=/home/pbruss/NORA/keys/student-admin_key

ssh -i ${STUDENT_ADMIN_KEY_PATH} -p ${PORT} -o StrictHostKeyChecking=no student-admin@${MACHINE}
