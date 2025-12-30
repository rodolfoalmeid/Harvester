# Harvester VM with Garage S3 Bucket
This project uses Terraform to create a Virtual Machine (VM) on a Harvester cluster. It automatically installs and configures Garage, a lightweight S3-compatible object storage server.

By using this script, you will get a ready-to-use S3 bucket running on openSUSE Leap 15.6.

## Prerequisites
Before you start, make sure you have:

1. Terraform and virtctl is installed on your computer.
2. Access to a Harvester cluster.
3. A kubeconfig file to connect to your Harvester cluster.
4. An SSH public key to access the VM.

## Project Files

- **main.tf**: The main Terraform configuration that creates the VM, Network, and Cloud-init secrets.
- **variables.tf**: Defines the variables used in the project.
- **versions.tf**: Terraform provider versions.
- **terraform.tfvars**: A file where you set your specific variables (IPs, passwords, paths).
- **output.tf**: Print VM IP Address after running the terraform script.
- **setup.sh.tpl**: A script that runs inside the VM to install Garage S3, create a bucket, and generate keys.
- **user-data.yaml.tpl**: User cloud-init settings. Update OS package, install required packages, creates a user, creates the script to install S3 Bucket and run the script.
- **network-data.yaml.tpl**: Network cloud-init settings to set static IP to the VM .


## Configuration
1. Clone this repository to your local machine.
2. Edit the terraform.tfvars file with your settings. You must change the following values:
    - **namespace**: Creates a new namespace where all resources will be allocated.
    - **vm_name**: Define the name of the VM.
    - **network_name**: A new untagged network will be created assigned to the management cluster network.
    - **vm_user**: User name created to access the VM
    - **vm_password**: A secure password for the user `vm_user`. Note: It is required a hashed password. To generate a hashed password, you can run the command `openssl passwd -6
    - **ssh_public_key**: Your SSH public key (starts with ssh-rsa or ssh-ed25519).
    - **harvester_kubeconfig**: The path to your Harvester kubeconfig file.
    - **vm_ip_address**: The static IP you want for the VM (e.g., 192.168.122.252/24).
    - **vm_gateway**: The network gateway IP.
    - **garage_version**: URL to the desired binary version that will be installed.
    - **bucket_region**: Bucket region name.
    - **bucket_name**: Bucket name.

    >NOTE: If you need a specific version of Garage other than the default provided in the script:
    > - Visit the Garage Releases Page. https://garagehq.deuxfleurs.fr/download/
    > - Find the binary version you want.
    > - Right-click on the Linux (amd64/x86_64) option and copy the link.
    > - Update the garage_version variable.


## How to Run
Open your terminal in the project folder and run the following commands:

1. Initialize Terraform:

    ```Bash
    terraform init
    ```

2. Preview the changes:
    ```Bash
    terraform plan
    ```

3. Apply the configuration:
    ```Bash
    terraform apply
    ```
    Type yes when asked to confirm.


## Accessing Your S3 Bucket
Once the Terraform script finishes, the VM will be created. The installation script inside the VM takes about 1 minute to complete.

1. Connect to the VM

    Use SSH to connect to the VM using the IP you defined:
    ``` Bash
    ssh user@<YOUR_VM_IP>
    ```
    (The default user is tux).

2. Get S3 Credentials
The setup script generates a file with all the connection details, including the Access Key and Secret Key. You can read this file by running:

    ```Bash
    cat /opt/harvester-s3bucket-settings.txt
    ```

    You will see output similar to this:

    ```Plaintext
    Harvester Settings Info:
    Endpoint          = http://192.168.122.252:3900
    Bucket Name       = bucket1
    Bucket Region     = north1
    Access Key ID     = <GENERATED_KEY>
    Secret Access Key = <GENERATED_SECRET>
    ```

## VM Specifications
The VM is created with the following default resources:
- OS: openSUSE Leap 15.6 
- CPU: 4 Cores 
- Memory: 6 GiB 
- Disk: 100 GiB 
- Garage Layout: Zone1 with 50GB capacity

## How to destroy
If you want to remove the VM and all objects created using this script please run:
```bash
terraform destroy
```
> ATTENTION: Before destroying the installation, please make sure that all resources created inside the S3 bucket namespace, after the installation must be removed, othewise the terraform destroy will fail.