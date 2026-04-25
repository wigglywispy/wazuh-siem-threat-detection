#!/bin/bash
# Brute-Force SSH Simulation Script
# Target: Wazuh Agent VM (192.168.56.20)
# Run this from the Wazuh Server VM (192.168.56.10)
# Purpose: Simulate a brute-force SSH attack to trigger Wazuh Rule 5710/5763

TARGET_IP="192.168.56.20"
ATTEMPTS=15

echo "Starting brute-force simulation against $TARGET_IP..."

for i in $(seq 1 $ATTEMPTS); do
  sshpass -p 'wrongpassword' ssh -o 'StrictHostKeyChecking no' wronguser@$TARGET_IP 2>/dev/null || true
  echo "Attempt $i of $ATTEMPTS done"
  sleep 0.5
done

echo "Done!"
