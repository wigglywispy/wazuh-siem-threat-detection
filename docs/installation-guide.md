# Installation Guide

## Prerequisites

- VirtualBox installed on host machine
- Ubuntu Server 22.04 LTS ISO downloaded
- Minimum 8 GB RAM on host machine
- Minimum 60 GB free disk space

---

## VM1 — Wazuh Server Setup

### 1. Create the VM in VirtualBox
- RAM: 4096 MB
- CPU: 2 vCPUs
- Storage: 50 GB (dynamically allocated)
- Network Adapter 1: NAT
- Network Adapter 2: Internal Network — name: `wazuh-lab`

### 2. Install Ubuntu Server 22.04
- Enable OpenSSH during installation
- Note your username and password

### 3. Configure Static IP
Edit `/etc/netplan/00-installer-config.yaml`:
```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      addresses:
        - 192.168.56.10/24
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```
Apply: `sudo netplan apply`

### 4. Install Wazuh All-in-One
```bash
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh
curl -sO https://packages.wazuh.com/4.7/config.yml
sudo bash wazuh-install.sh --generate-config-files
sudo bash wazuh-install.sh --wazuh-indexer node-1
sudo bash wazuh-install.sh --start-cluster
sudo bash wazuh-install.sh --wazuh-server wazuh-1
sudo bash wazuh-install.sh --wazuh-dashboard dashboard
```

### 5. Verify Services
```bash
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-indexer
sudo systemctl status wazuh-dashboard
```

### 6. Access Dashboard
Open browser on host: `https://192.168.56.10`
Login with credentials shown at the end of installation.

---

## VM2 — Wazuh Agent Setup

### 1. Create the VM in VirtualBox
- RAM: 2048 MB
- CPU: 2 vCPUs
- Storage: 20 GB (dynamically allocated)
- Network Adapter 1: NAT
- Network Adapter 2: Internal Network — name: `wazuh-lab`

### 2. Install Ubuntu Server 22.04
- Same process as VM1
- Enable OpenSSH during installation

### 3. Configure Static IP
Edit `/etc/netplan/00-installer-config.yaml`:
```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      dhcp4: true
    enp0s8:
      addresses:
        - 192.168.56.20/24
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```
Apply: `sudo netplan apply`

### 4. Add Wazuh Repository
```bash
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH -o /tmp/wazuh.gpg
sudo gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import /tmp/wazuh.gpg
sudo chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee /etc/apt/sources.list.d/wazuh.list
sudo apt-get update
```

### 5. Install the Agent
```bash
sudo WAZUH_MANAGER='192.168.56.10' apt-get install wazuh-agent -y
```

### 6. Enable and Start
```bash
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
```

### 7. Verify Connection
Check dashboard at `https://192.168.56.10` → Agents → should show Wazuh-Agent as Active.
