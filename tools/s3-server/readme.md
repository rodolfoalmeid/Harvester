# S3 Bucket Server for Harvester Backup

![OS](https://img.shields.io/badge/OS-Ubuntu%20%7C%20openSUSE-green)

This repository contains a script to automate the deployment and configuration of an S3-compatible object storage server using **Garage**. This setup is specifically designed to serve as a lightweight, self-hosted backup target for [Harvester](https://harvesterhci.io/).

The script automatically handles the download of the Garage binary, system configuration, and service creation.

## 📋 Features

* **Automated Installation:** Installs Garage S3 Bucket Binary.
* **Directory Setup:** Creates and sets permissions for the backup directory.
* **Service Management:** Enables and starts the necessary system services.
* **Output Settings for Harvester:** Output the required fields to configure Harvester.

## 💻 Supported Operating Systems

The script has been tested and verified on:

* **openSUSE Leap 15.6**
* **Ubuntu 24.04 LTS**

## 📋 Prerequisites

* A Virtual Machine (VM) running one of the supported OS versions.
* **Internet Access** (Required to download the Garage binary).
* Root or `sudo` privileges.

## ⚙️ Configuration

**⚠️ Important:** Before running the script, you **must** update the server IP address variable inside the file.

1.  Open the script: `vi setup_s3.sh`
2.  Locate the variable **`SRV_IP`**.
3.  Change the value to your server's actual IP address.

> **Optional:** You can also change the `DATA_DIR`, `META_DIR`, `GARAGE_VER`, and the `S3_REGION` inside the script if needed.

## 🛠️ Quick Run Instructions

Follow these steps to configure your server:

1. Create the Script File
Create a new file on your server:
```bash
vi setup_s3.sh
```
Paste the content of the script into this file and save it.

2. Set Permissions
Make the script executable:

```bash
chmod +x setup_s3.sh
```

3. Execute
Run the script using sudo:

```bash
sudo ./setup_s3.sh
```


### 🚀 Output & Usage

As soon as the script finishes, it will display the specific settings required for Harvester.

Example Output:

```plaintext
Harvester Settings Info:
Endpoint          = http://192.168.68.28:3900
Bucket Name       = harvbucket
Bucket Region     = homelab
Access Key ID     = GK6bfe01acb1cc1a1e81c7b10e
Secret Access Key = 7d43d8af74871762889767c96e142c1368de9d325ee57f0ba51e9d168ddc819c
```

### Configure Harvester
1. Go to your Harvester Dashboard.
2. Navigate to Backup settings.
3. Enter the details provided by the script output above (Endpoint, Bucket Name, Region, Access Key, and Secret Key).

### 🧩 Garage Versions
If you need a specific version of Garage other than the default provided in the script:

1. Visit the Garage Releases Page. https://garagehq.deuxfleurs.fr/download/
2. Find the binary version you want.
3. Right-click on the Linux (amd64/x86_64) option and copy the link.
4. Update the download link in the script.


