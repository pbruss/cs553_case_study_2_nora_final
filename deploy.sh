#!/bin/bash
# CS/DS533 Case Study 2
# A file used to deploy NORA on the remote virtual machine, includes the installation of the virtual python environment

# Set bash options for better error handling
set -euo pipefail
trap 'echo "An error occurred. Exiting."' ERR

PORT=22014
MACHINE="paffenroth-23.dyn.wpi.edu"
TMP_DIR="tmp"
KEY_PATH="${TMP_DIR}/mykey"

# Ensure SSH agent is started
eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

# Define reusable SSH options
SSH_OPTIONS="-i $KEY_PATH -p $PORT -o StrictHostKeyChecking=no"
SSH_COMMAND="ssh $SSH_OPTIONS student-admin@$MACHINE"

# Run commands on the remote server
echo "Checking that the code repository is installed..."
$SSH_COMMAND "ls cs553_case_study_1_nora_final"

echo "Installing Python virtual environment..."
$SSH_COMMAND "sudo apt install -qq -y python3-venv"

echo "Creating Python virtual environment..."
$SSH_COMMAND "cd cs553_case_study_1_nora_final && python3 -m venv venv"

echo "Activating virtual environment and installing dependencies..."
$SSH_COMMAND "cd cs553_case_study_1_nora_final && source venv/bin/activate && pip install -r requirements.txt"

echo "Starting the application in the background..."
$SSH_COMMAND "nohup cs553_case_study_1_nora_final/venv/bin/python3 cs553_case_study_1_nora_final/app.py > log.txt 2>&1 &"

# Cleanup SSH agent
echo "Killing ssh-agent..."
ssh-agent -k

echo "Script completed successfully."
