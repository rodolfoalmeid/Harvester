Harvester
====================

> Rodolfo Rebelato de Almeida | November 15th, 2021

--------------------------


This repository, will be just to host the tests I have done with Harvester software.

> Documentation
    https://docs.harvesterhci.io/v1.1

> ISO download
   https://github.com/harvester/harvester/releases/
   
---------------
# Table of Contents

1. [Team training](#team-training)
2. [Harvester-Deployment](#harvester-deployment-using-terraform)


Team training
====================

https://confluence.suse.com/display/HARV/Harvester+Support+Training

https://confluence.suse.com/display/HARV/Harvester+Support+and+Troubleshooting+Deep+Dive


Harvester Deployment using Terraform
====================

This tutorial will demonstrate how to create a Lab for Harvester in Equinix.

We will user Terraform and a sample script to deploy it.

Also, we will use IPXE scripts to boot Harvester from the correct image and prepare the environment.

Number of nodes can be changed according to the needs.

Harvester: v1.0.0, v1.0.1, v1.0.2, v1.0.3, v1.1.0 

## 0 - Pre-requisites

Install Git (https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

Install Terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli) 

## 1 - Create a folder for Harvester on your PC

mkdir Harvester-Lab

## 2 - Clone the Repository into the folder

cd Harvester-Lab

git clone https://github.com/rancherlabs/harvester-equinix-terraform.git 

** Credentials intruction to clone a repo from GitHub

https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls

![image](https://user-images.githubusercontent.com/113181949/201944615-6017eee6-d118-4c7e-a195-ffb485689b0f.png)


## 3 - Change directory into "harvester-equinix-terraform"

cd harvester-equinix-terraform

![image](https://user-images.githubusercontent.com/113181949/201944676-542b1925-71b5-4cdd-a870-d16267f48316.png)


## 4 - (Optional) - Open the folder in VSCODE

![image](https://user-images.githubusercontent.com/113181949/201944727-9c7c78fb-aeee-4a69-a3db-2112696f7eaf.png)


## 5 - Create a new file called terraform.tfvars with the following content

> terraform.tfvars

harvester_version = "v1.0.3"                # change the harvester version according to your needs
hostname_prefix   = "<yourname>-harvester" 
node_count        = "2"                     # change the number of nodes according to your needs
project_name      = "Harvester Labs"        
plan              = "m3.small.x86" # $0.11
#plan              = "c2.medium.x86" # $0.50
#plan              = "c3.medium.x86" # $0.36
max_bid_price     = "0.11"
metro             = "SV"
facility          = "sv15"
spot_instance     = true
ssh_key           = "ssh-rsa youruser"      # insert here your public ssh keys

# Below are the IPXE scripts for Harvester. Uncomment the one that suits your needs.
#ipxe_script       = "https://raw.githubusercontent.com/dnoland1/harvester-equinix-terraform-sample/ipxe/ipxe1.0.0"
#ipxe_script       = "https://raw.githubusercontent.com/dnoland1/harvester-equinix-terraform-sample/ipxe/ipxe1.0.1"
#ipxe_script       = "https://raw.githubusercontent.com/dnoland1/harvester-equinix-terraform-sample/ipxe/ipxe1.0.2"
ipxe_script       = "https://raw.githubusercontent.com/dnoland1/harvester-equinix-terraform-sample/ipxe/ipxe1.0.3"


## 6 - In the terminal, go back into your folder and execute "terraform init"

cd Harvester-Lab

cd harvester-equinix-terraform

terraform init

##7 - Go to Equinix Portal, create your API Keys and copy them

![image](https://user-images.githubusercontent.com/113181949/201945096-acb5a122-34df-4c80-8bf9-3b34e03fee3d.png)

## 8 - Back in the terminal, you are going to use your API Keys as an environment variable called `METAL_AUTH_TOKEN`

export METAL_AUTH_TOKEN=<your-api-key>

## 9 - When ready, execute "terraform apply"

terraform apply

When prompted with the following message, review the items that are going to be created, and if it ok, type "yes"

![image](https://user-images.githubusercontent.com/113181949/201945183-1c790848-fdfc-4987-a761-a760b5735a84.png)

When done, you should see the Harvester URL in the output:

""Outputs:

harvester_url = "https://147.75.49.110/"
Note this URL for later.""

## 10 - Back in Equinix Portal, you will see your hosts being deployed into Equinix

![image](https://user-images.githubusercontent.com/113181949/201945312-0406198f-69a3-4d46-9354-c18dfc8a8711.png)


## 11 - Connecting to the hosts
At this point, you can click the three dots under "Actions", and it is possible to connect to your hosts in two ways:

### 1 - Connect using Out-of-band ssh:

This option uses Serial-Over-SSH, and therefore it is possible to see Harvester being installed and the steps it is taking.
You can also monitor for possible failures

### 2 - Connect using SSH:

When it becomes available, you can connect via ssh using 

ssh rancher@<your-host-ip>

### 3- Connect to Harvester UI:

On a web browser, navigate to the URL shown in the terraform output. Note, the default password is "admin" and not the password generated by Terraform and passed in user-data (that needs to be fixed!)
