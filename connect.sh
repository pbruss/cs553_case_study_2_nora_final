#! /bin/bash

PORT=22014
MACHINE=paffenroth-23.dyn.wpi.edu

ssh -i tmp/mykey -p ${PORT} -o StrictHostKeyChecking=no student-admin@${MACHINE}
