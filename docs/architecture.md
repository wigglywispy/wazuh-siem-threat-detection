# Architecture

## Overview

This lab consists of two virtual machines connected via a private internal network, simulating a real-world SIEM deployment where a central server monitors a remote endpoint.

## Network Diagram

```
+----------------------+     Internal Network (192.168.56.0/24)     +----------------------+
|   VM1: Wazuh Server  |<----------------------------------------->|  VM2: Target Machine  |
|   192.168.56.10      |        Port 1514 (Agent Communication)     |  192.168.56.20        |
|                      |        Port 1515 (Agent Registration)      |                       |
|                      |        Port 443  (Dashboard HTTPS)         |                       |
|  - Wazuh Manager     |                                            |  - Wazuh Agent        |
|  - Wazuh Indexer     |                                            |  - SSH Server         |
|  - Wazuh Dashboard   |                                            |  - Attack Target      |
+----------------------+                                            +----------------------+
         |                                                                    |
         | NAT (internet)                                              NAT (internet)
         |                                                                    |
    Package downloads                                                  Package downloads
```

## Components

### VM1 — Wazuh Server
| Component | Role |
|-----------|------|
| Wazuh Manager | Receives logs and events from agents, applies rules, generates alerts |
| Wazuh Indexer | Stores all security events (OpenSearch-based) |
| Wazuh Dashboard | Web UI for visualising alerts, agents, and MITRE ATT&CK mappings |

### VM2 — Target Machine
| Component | Role |
|-----------|------|
| Wazuh Agent | Collects logs and system events, forwards them to the Manager |
| SSH Server | Target for brute-force simulation |
| Monitored Directory | /home/agent/monitored — watched by FIM engine |

## Communication Flow

1. Wazuh Agent on VM2 collects system logs (auth.log, syscheck, etc.)
2. Agent forwards events to Wazuh Manager on VM1 via port 1514 (TCP)
3. Manager applies detection rules and generates alerts
4. Alerts are stored in the Wazuh Indexer
5. Wazuh Dashboard reads from the Indexer and displays alerts in real time

## Network Configuration

| VM | Adapter 1 | Adapter 2 |
|----|-----------|-----------|
| VM1 (Server) | NAT — DHCP (internet access) | Internal Network — 192.168.56.10/24 |
| VM2 (Agent) | NAT — DHCP (internet access) | Internal Network — 192.168.56.20/24 |
