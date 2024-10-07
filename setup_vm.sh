#!/bin/bash

# Set bash options for better error handling
set -euo pipefail
trap 'echo "An error occurred. Exiting."' ERR

PORT=${PORT:-22014}
MACHINE=${MACHINE:-"paffenroth-23.dyn.wpi.edu"}
STUDENT_ADMIN_KEY_PATH=${STUDENT_ADMIN_KEY_PATH:-"/home/pbruss/NORA/keys"}
REPO_URL=${REPO_URL:-"https://github.com/pbruss/cs553_case_study_1_nora_final"}

# Create a unique temporary directory
TMP_DIR=$(mktemp -d)
trap 'cleanup' EXIT

cleanup() {
  echo "Cleaning up temporary files..."
  rm -rf "$TMP_DIR"
  echo "Killing ssh-agent..."
  ssh-agent -k
}

echo "Using temporary directory: $TMP_DIR"

# Copy the key to the temporary directory
cp "${STUDENT_ADMIN_KEY_PATH}/student-admin_key"* "$TMP_DIR"
chmod 600 "$TMP_DIR/student-admin_key"*

# Remove old host key from known_hosts (only if present)
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[${MACHINE}]:${PORT}" || true

# Generate a new SSH key pair
echo "Generating new SSH key pair..."
ssh-keygen -f "$TMP_DIR/mykey" -t ed25519 -q

# Create or update the authorized_keys file securely
AUTHORIZED_KEYS="$TMP_DIR/authorized_keys"
echo "Creating/updating the authorized_keys file..."
cat "$TMP_DIR/mykey.pub" > "$AUTHORIZED_KEYS"
chmod 600 "$AUTHORIZED_KEYS"

# Verify the contents of authorized_keys
echo "Checking the authorized_keys file:"
ls -l "$AUTHORIZED_KEYS"
cat "$AUTHORIZED_KEYS"

# SSH options
SSH_OPTIONS="-P $PORT -o UserKnownHostsFile=$TMP_DIR/known_hosts -o StrictHostKeyChecking=no"

# Copy the authorized_keys file to the server for group 14
echo "Copying the authorized_keys file to the server..."
scp $SSH_OPTIONS -i "$TMP_DIR/student-admin_key" "$AUTHORIZED_KEYS" student-admin@"$MACHINE":~/.ssh/

# Start ssh-agent and add the new key
echo "Adding the new key to the ssh-agent..."
eval "$(ssh-agent -s)"
ssh-add "$TMP_DIR/mykey"

# Verify authorized_keys on the server for group 14
echo "Verifying the authorized_keys file on the server..."
ssh $SSH_OPTIONS student-admin@"$MACHINE" "cat ~/.ssh/authorized_keys"

# Clone the GitHub repository containing the product (NORA)
echo "Cloning the repository..."
git clone "$REPO_URL" "$TMP_DIR/cs553_case_study_1_nora_final" || {
  echo "Error: Failed to clone repository"
  exit 1
}

# Copy the repository to the server for group 14
echo "Copying the cloned repository to the server..."
scp $SSH_OPTIONS -r "$TMP_DIR/cs553_case_study_1_nora_final" student-admin@"$MACHINE":~/

echo "Script completed successfully."
