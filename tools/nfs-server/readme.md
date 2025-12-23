# NFS Server Setup for Harvester Backup Target

![OS](https://img.shields.io/badge/OS-Ubuntu%20%7C%20openSUSE-green)

This repository contains a two shell scripts to automate the configuration of an NFS server for SLES or Ubuntu. It is specifically designed to prepare a Virtual Machine or Bare Metal server to serve as a **Backup Target** for [Harvester](https://harvesterhci.io/).

## 📋 Features

* **Automated Installation:** Installs necessary NFS kernel server packages.
* **Directory Setup:** Creates and sets permissions for the backup directory.
* **Export Configuration:** Configures `/etc/exports` automatically.
* **Firewall Management:** Adjusts firewall rules (Firewalld for SUSE, UFW for Ubuntu) to allow NFS traffic.
* **Service Management:** Enables and starts the necessary system services.

## 💻 Supported Operating Systems

The script has been tested and verified on:

* **openSUSE Leap 15.6**
* **Ubuntu 24.04 LTS**

## 🚀 Quick Run Instructions

You can set up your NFS server in minutes by following these steps.

### Prerequisites
* A fresh VM or server running one of the supported operating systems.
* Root or `sudo` privileges.
* Internet connectivity.

### Installation Steps

1.  **Create the VM/Server** and SSH into it.

2.  **Create the script file:**
    ```bash
    vi setup_nfs.sh
    ```

3.  **Paste the content** of the script (from this repository) into the file and save it (`ESC` -> `:wq`).

4.  **Make the script executable:**
    ```bash
    chmod +x setup_nfs.sh
    ```

5.  **Execute the script:**
    ```bash
    sudo ./setup_nfs.sh
    ```

---

## ⚙️ Configuration Details

By default, the script creates a share at `/nfs/backups` (or whichever path is defined in the script).

### Post-Installation (Harvester Configuration)

Once the script finishes successfully:

1.  Log in to your **Harvester UI**.
2.  Navigate to **Settings** > **Backup Target**.
3.  Click **Edit**.
4.  Select **NFS** as the type.
5.  **Endpoint:** Enter the IP address of this server and the path created.
    * *Example:* `nfs://192.168.1.50:/nfs/backups`
6.  Click **Save/Test Connection**.

## 🛠️ What the script does

1.  **Chosse the script according to the OS:** Determines if the system is Debian-based (Ubuntu) or RPM-based (openSUSE).
2.  **Updates Repositories:** Refreshes package lists.
3.  **Installs Packages:** NFS packege according to the OS.
4.  **Configures Exports:** Adds the export line to `/etc/exports` with `rw,sync,no_subtree_check` options.
5.  **Configures Firewall:** Opens port `2049` and other necessary RPC ports.

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
