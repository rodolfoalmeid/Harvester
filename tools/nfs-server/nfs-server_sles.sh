#!/bin/bash

# ==========================================
# NFS Server Setup Script for openSUSE/SLES
# ==========================================

# Configuration Variables
BACKUP_DIR="/mnt/backup"
EXPORTS_FILE="/etc/exports"
NFS_SERVICE="nfs-server.service"

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script as root (sudo)."
  exit 1
fi

echo "--- Starting NFS Server Configuration ---"

# 1. Create the directory to store backups
echo "[1/6] Creating directory $BACKUP_DIR..."
# -p flag creates parent directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# 2. Set directory permissions
# Note: SLES/openSUSE uses 'nobody:nobody'
echo "[2/6] Setting permissions..."
chown nobody:nobody "$BACKUP_DIR"
chmod -R 777 "$BACKUP_DIR"

# 3. Install NFS service using Zypper
echo "[3/6] Installing nfs-kernel-server..."
# Refresh repositories
zypper refresh
# Install package non-interactively (-y)
zypper install -y nfs-kernel-server

# Enable and start the service
echo "      Enabling and starting $NFS_SERVICE..."
systemctl enable $NFS_SERVICE
systemctl start $NFS_SERVICE

# 4. Configure Firewall (New Step)
echo "[4/6] Configuring Firewall..."
# Allow NFS, RPC-Bind, and Mountd services permanently
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
# Reload firewall to apply changes
firewall-cmd --reload
echo "      Firewall rules updated."

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