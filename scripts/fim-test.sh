#!/bin/bash
# File Integrity Monitoring (FIM) Test Script
# Run this on the Wazuh Agent VM (192.168.56.20)
# Purpose: Simulate file tampering to trigger Wazuh Rules 550/553/554

MONITOR_DIR="/home/agent/monitored"

echo "Starting FIM simulation in $MONITOR_DIR..."

# Step 1: Create a suspicious file
echo "Creating file..."
echo 'malicious_payload' > $MONITOR_DIR/malware_test.sh

# Step 2: Modify the file
sleep 5
echo "Modifying file..."
echo 'modified by attacker' >> $MONITOR_DIR/malware_test.sh

# Step 3: Create another file
echo "Creating second file..."
touch $MONITOR_DIR/suspicious.conf

# Step 4: Delete a file
sleep 5
echo "Deleting file..."
rm $MONITOR_DIR/suspicious.conf

echo "Done! Check Wazuh dashboard for syscheck alerts (Rules 550, 553, 554)."
