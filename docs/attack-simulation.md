# Attack Simulations

## Overview

Three attack types were simulated to test Wazuh detection capabilities. All simulations were performed in an isolated lab environment on machines owned by the researcher.

---

## 1. SSH Brute-Force Attack

### What It Simulates
An attacker attempting to gain unauthorised access by rapidly trying multiple passwords against an SSH service.

### Why It Is Suspicious
Normal users do not fail to log in 10+ times in rapid succession from the same IP address. This pattern is a textbook brute-force indicator.

### Commands Used
```bash
# Install sshpass on VM1
sudo apt-get install sshpass -y

# Run brute-force loop
for i in {1..15}; do
  sshpass -p 'wrongpassword' ssh -o 'StrictHostKeyChecking no' wronguser@192.168.56.20 2>/dev/null || true
  sleep 0.5
done
```

### Wazuh Detection
| Rule ID | Description | Level |
|---------|-------------|-------|
| 5710 | sshd: Attempt to login using a non-existent user | 5 |
| 5503 | PAM: User login failed | 5 |

### MITRE ATT&CK Mapping
- **T1110.001** — Brute Force: Password Guessing
- **T1021.004** — Remote Services: SSH

---

## 2. File Integrity Monitoring (FIM)

### What It Simulates
An attacker or malware creating, modifying, or deleting files in sensitive directories — commonly used to drop payloads, modify configs, or cover tracks.

### Why It Is Suspicious
Unexpected file changes in monitored directories — especially at odd hours or by unknown processes — are strong indicators of compromise.

### Commands Used
```bash
# Run on VM2
MONITOR_DIR="/home/agent/monitored"

# Create a file
echo 'malicious_payload' > $MONITOR_DIR/malware_test.sh

# Modify the file
sleep 5
echo 'modified by attacker' >> $MONITOR_DIR/malware_test.sh

# Create another file
touch $MONITOR_DIR/suspicious.conf

# Delete a file
sleep 5
rm $MONITOR_DIR/suspicious.conf
```

### Wazuh Detection
| Rule ID | Description | Level |
|---------|-------------|-------|
| 554 | File added to the system | 7 |
| 550 | File integrity checksum changed | 7 |
| 553 | File deleted | 7 |

### MITRE ATT&CK Mapping
- **T1565** — Data Manipulation

---

## 3. Network Scan (Optional)

### What It Simulates
An attacker performing reconnaissance to discover open ports and services on a target machine before launching an attack.

### Why It Is Suspicious
A single source rapidly connecting to many ports in a short time is not normal user behaviour. It indicates someone mapping the network for vulnerabilities.

### Commands Used
```bash
# Install nmap on VM1
sudo apt-get install nmap -y

# Basic service scan
nmap -sV 192.168.56.20

# Aggressive scan
nmap -A -T4 192.168.56.20
```

### Expected Output
```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu
```

### MITRE ATT&CK Mapping
- **T1046** — Network Service Discovery
