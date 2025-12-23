#!/bin/bash

# ==========================================
# NFS Server Setup Script for Ubuntu
# ==========================================

# Configuration Variables
BACKUP_DIR="/mnt/backup"
EXPORTS_FILE="/etc/exports"
# On Ubuntu, the service unit is typically named nfs-kernel-server
NFS_SERVICE="nfs-kernel-server"

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script as root (sudo)."
  exit 1
fi

echo "--- Starting NFS Server Configuration (Ubuntu) ---"

# 1. Create the directory to store backups
echo "[1/6] Creating directory $BACKUP_DIR..."
# -p flag creates parent directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# 2. Set directory permissions
# Note: Ubuntu/Debian typically uses 'nobody:nogroup' for anonymous access
echo "[2/6] Setting permissions..."
chown nobody:nogroup "$BACKUP_DIR"
chmod -R 777 "$BACKUP_DIR"

# 3. Install NFS service using APT
echo "[3/6] Installing nfs-kernel-server..."
# Update package lists
apt-get update
# Install package non-interactively (-y)
apt-get install -y nfs-kernel-server

# Enable and start the service
echo "      Enabling and starting $NFS_SERVICE..."
systemctl enable $NFS_SERVICE
systemctl start $NFS_SERVICE

# 4. Configure Firewall (UFW)
echo "[4/6] Configuring Firewall..."
# Check if ufw is installed and active
if command -v ufw > /dev/null; then
    # Allow standard NFS traffic
    # 'allow nfs' is a pre-configured profile in UFW that covers port 2049
    ufw allow nfs
    # Reload firewall to apply changes
    ufw reload
    echo "      UFW rules updated."
else
    echo "      Warning: UFW not found. If you are using a different firewall, please open port 2049 manually."
fi

# 5. Backup the default NFS server settings and Configure Exports
echo "[5/6] Configuring exports file..."

if [ -f "$EXPORTS_FILE" ] && [ ! -f "${EXPORTS_FILE}.orig" ]; then
    cp "$EXPORTS_FILE" "${EXPORTS_FILE}.orig"
    echo "      Backup created at ${EXPORTS_FILE}.orig"
fi

# Create new exports configuration
# Options explanation:
# rw - read and write
# sync - reply to requests only after changes have been committed to stable storage
# no_subtree_check - disable subtree checking (improves reliability)
# no_root_squash - allow root on client to have root privileges on server
# insecure - Allow connections from high (unprivileged) ports
echo "      Adding configuration line..."
# WARNING: This overwrites the existing exports file. Use '>>' to append instead if you have existing shares.
echo "$BACKUP_DIR *(rw,sync,no_subtree_check,no_root_squash,insecure)" > "$EXPORTS_FILE"

# 6. Apply changes and restart service
echo "[6/6] Applying changes..."
exportfs -rav
systemctl restart $NFS_SERVICE

echo "---"
echo "✅ Configuration completed successfully!"
echo "---"

# Verification step
echo "Current Export List (showmount):"
showmount -e localhost