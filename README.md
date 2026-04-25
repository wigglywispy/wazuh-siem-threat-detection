# 🛡️ SIEM-Based Threat Detection Using Wazuh

![Wazuh](https://img.shields.io/badge/Wazuh-4.x-blue)
![Platform](https://img.shields.io/badge/Platform-Ubuntu%2022.04-orange)
![VirtualBox](https://img.shields.io/badge/Virtualization-VirtualBox-lightblue)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

## Overview

A hands-on cybersecurity home lab project demonstrating Security Information and Event Management (SIEM) capabilities using the open-source Wazuh platform. This project simulates real-world attack scenarios and demonstrates how a SIEM detects, logs, and alerts on suspicious activity in real time.

---

## Architecture

```
+----------------------+     Internal Network (192.168.56.0/24)     +----------------------+
|   VM1: Wazuh Server  |<----------------------------------------->|  VM2: Target Machine  |
|   192.168.56.10      |        Port 1514 (Agent Communication)    |  192.168.56.20        |
|                      |        Port 443  (Dashboard)              |                       |
|  - Wazuh Manager     |                                           |  - Wazuh Agent        |
|  - Wazuh Indexer     |                                           |  - SSH Server         |
|  - Wazuh Dashboard   |                                           |  - Attack Target      |
+----------------------+                                           +-----------------------+
```

---

## Tools & Technologies

| Tool | Purpose | Version |
|------|---------|---------|
| Wazuh | SIEM platform (manager, indexer, dashboard) | 4.7.5 |
| VirtualBox | Virtualization | 7.x |
| Ubuntu Server | OS for both VMs | 22.04 LTS |
| sshpass | SSH brute-force simulation | - |
| Nmap | Network scanning simulation | 7.x |

---

## Environment Setup

| Component | Specification |
|-----------|--------------|
| VM1 RAM | 4096 MB |
| VM1 Storage | 50 GB |
| VM2 RAM | 2048 MB |
| VM2 Storage | 20 GB |
| Network | Internal Network (wazuh-lab) + NAT |
| VM1 IP | 192.168.56.10 |
| VM2 IP | 192.168.56.20 |

---

## Installation Summary

1. Created two Ubuntu Server 22.04 VMs in VirtualBox
2. Configured static IPs on the Internal Network adapter using Netplan
3. Installed Wazuh all-in-one on VM1 (Manager + Indexer + Dashboard)
4. Installed and configured Wazuh Agent on VM2 pointing to 192.168.56.10
5. Verified agent connection in the Wazuh Dashboard

See full installation steps in [`docs/`](docs/)

---

## Attack Simulations

### 1. 🔐 SSH Brute-Force Attack
Simulated a dictionary-based brute-force attack using sshpass generating multiple failed SSH authentication attempts against VM2.

- **Tool:** sshpass + SSH loop
- **Command:** see [`scripts/brute-force-sim.sh`](scripts/brute-force-sim.sh)
- **Wazuh Rules Triggered:** 5710, 5503
- **MITRE ATT&CK:** T1110.001 (Brute Force: Password Guessing), T1021.004
- **Alert Level:** 5

### 2. 📁 File Integrity Monitoring (FIM)
Simulated unauthorized file creation, modification, and deletion inside a monitored directory to trigger Wazuh's FIM engine.

- **Tool:** Bash commands (touch, echo, rm)
- **Command:** see [`scripts/fim-test.sh`](scripts/fim-test.sh)
- **Wazuh Rules Triggered:** 554 (added), 550 (modified), 553 (deleted)
- **MITRE ATT&CK:** T1565 (Data Manipulation)
- **Alert Level:** 7

### 3. 🌐 Network Scan (Optional)
Simulated network reconnaissance using Nmap to probe open ports on VM2.

- **Tool:** Nmap
- **Command:** `nmap -sV 192.168.56.20`
- **Purpose:** Simulate attacker reconnaissance phase

---

## Results

All simulated attacks were successfully detected by Wazuh:

| Attack | Tool | Rule ID | Level | MITRE | Detected |
|--------|------|---------|-------|-------|---------|
| SSH Brute Force | sshpass | 5710, 5503 | 5 | T1110.001 | ✅ YES |
| File Created | touch/echo | 554 | 7 | T1565 | ✅ YES |
| File Modified | echo >> | 550 | 7 | T1565 | ✅ YES |
| File Deleted | rm | 553 | 7 | T1565 | ✅ YES |

Screenshots of all alerts: [`screenshots/04-detection/`](screenshots/04-detection/)

---

## Screenshots

| Step | Screenshot |
|------|-----------|
| VirtualBox VM list | [View](screenshots/01-environment/) |
| Agent connected (Active) | [View](screenshots/02-installation/) |
| Wazuh Security Events dashboard | [View](screenshots/04-detection/) |
| Alert detail - Rule 5710 | [View](screenshots/04-detection/) |
| FIM alert detail | [View](screenshots/04-detection/) |

---

## Lessons Learned

- Understood how attacker actions (failed logins, file changes) appear as patterns in system logs
- Learned how a SIEM correlates individual log events into meaningful security alerts
- Gained hands-on experience navigating and interpreting the Wazuh dashboard
- Understood MITRE ATT&CK technique mapping in a real detection context
- Practiced setting up isolated virtual network environments for security testing

---

## Conclusion

This lab demonstrates core SOC analyst competencies including deploying a SIEM platform, connecting monitored endpoints, simulating realistic attack scenarios, and interpreting security alerts. The project reflects real-world security monitoring workflows at a foundational level and serves as a practical foundation for further study in threat detection and incident response.

---

*Author: Steven Santoso | [LinkedIn](www.linkedin.com/in/steven--santoso) 
