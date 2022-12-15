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
3. [Harvester Training](#harvester-training)
4. [Live Migration and Redundancy](#live-migration-and-redundancy)



Team training
====================

https://confluence.suse.com/display/HARV/Harvester+Support+Training

https://confluence.suse.com/display/HARV/Harvester+Support+and+Troubleshooting+Deep+Dive

--------------------------


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

--------------------------


Harvester Training
====================

![image](https://user-images.githubusercontent.com/113181949/205135543-fa5a6b46-d1ca-4e7d-8c86-f1e3d42b7592.png)

![image](https://user-images.githubusercontent.com/113181949/205135694-f24812f7-d822-40b4-af6a-1204b319d135.png)

> KubeVirt - Uses kubernetes and libevirt as virtualization solution

> Network Layer - CNIs stands for Container network interface

![image](https://user-images.githubusercontent.com/113181949/205136107-35a9b4d4-80ea-4c84-9933-5a7ed67ce921.png)

## Harvester Installation Process

- It is designed to be installed on bare metal.

- Provides a platform to run virtual machines.


### Deploying methods

- Manual installation from ISO

- Manual installation from Network

- Automated installation from the network


### Deployment Process

- Create the cluster by deploying the initial cluster node.

- Additional cluster nodes can then be deployed and joined to the cluster.

(The first 3 cluster nodes will act as the controller nodes for the cluster and run processes such as etcd and the Kubernetes API.)


### Install a node and create a new cluster

1. Create a new Harvester cluster

![image](https://user-images.githubusercontent.com/113181949/205142132-a52c7a12-21f3-49ba-99ce-50e2e6bdc5de.png)


2. Select the disk to install the OS

![image](https://user-images.githubusercontent.com/113181949/205142722-3b62aeb7-e465-43db-8b69-2172cb14f300.png)


3. Network Configuration

![image](https://user-images.githubusercontent.com/113181949/205143034-a1581a14-6f00-4994-84a5-a796e5343379.png)

4. Configure DNS Servers

![image](https://user-images.githubusercontent.com/113181949/205143254-304d7226-e574-4c93-98d1-cd405da7a925.png)

5. Configure VIP

![image](https://user-images.githubusercontent.com/113181949/205143537-d56caaa9-9036-4acd-bcb7-e889076cd7c4.png)

6. Cluster Token

![image](https://user-images.githubusercontent.com/113181949/205143720-38ace35f-cd84-4237-abc9-013efca8fa4c.png)

7. Password to access the node

![image](https://user-images.githubusercontent.com/113181949/205143906-bcdc2f49-9a3b-40f1-965c-7f3368172601.png)

8. NTP Server

![image](https://user-images.githubusercontent.com/113181949/205144057-004f72df-9689-4e40-b50d-2f6c7d7a700a.png)

9. Proxy

![image](https://user-images.githubusercontent.com/113181949/205144214-47bce43e-236d-4243-9c3b-eb75179e899e.png)


10. Import SSH Keys

![image](https://user-images.githubusercontent.com/113181949/205144256-f740a15a-5c91-4ae9-b9b1-639b3120da1a.png)

11. Remote Harvester Configuration

![image](https://user-images.githubusercontent.com/113181949/205144629-96a35134-4cda-41d4-a54e-52921961dfe8.png)

12. 



Live Migration and Redundancy
=============================

https://docs.harvesterhci.io/v1.1/vm/live-migration

December 2022.

#### Case issue: Harvester do not migrate VMs automatically when Network data goes down.
Customer have their system running on version 1.1.1 and found a redundancy issue.
The customer told that when they disabled the network interfaces for one node, on the switch, the VMs were not migrated to the other available node where network interfaces are up.
Checking the node status they can see the interfaces down, and they are expecting that VMs were migrated to the available running nodes.
The customer expectation is that when data interface is down for one node VMs running on that node should be migrated to fully operation node as in current situation the VMs are just not accessible and nothing happen.


#### Guanbo Chen explanation: 
This is not supported in the current stage, and I don't  think Harvester should play the role of auto-pilot, for some cases, the admin would prefer to fix the network issues manually, or sometimes, there are VMs that can't be migrated to the other node and should be kept on the existing one, IMO the preferred path should be
 - configure related monitoring and alerts and send notification to the system admins.
 - enable the node maintenance mode e.g., via calling the API or some custom automation tools/script, then the VMs will be migrated to the other node accordingly.

Jira case was creted for RFE.


Change UI settings through CLI
===============================

#### Case issue: Customer cannot create a new storage class because the fileds in the parameters tab to configure the new storage class.

![storage_class](https://user-images.githubusercontent.com/113181949/207861795-402b33a3-b93a-44bd-9620-19c106cc0960.JPG)

### Case Resolution:

A Jira case was created for this issue and the engineering team recommended to change a parameter in the WebUI Settings.

1- WebUI configuration.

Go to Advanced >> Settings >> ui-source. Change the current value that should be auto to External. Please see the screenshots below.
After changing it, please clean the cache data and reload your browser.

![image](https://user-images.githubusercontent.com/113181949/207862841-2b85dee3-276b-4282-99c7-5f451af8e246.png)


2 - If this change doesn't take effect, please press F12 on your browser to open the browser developer tool, and search for errors in console/network.

Please check if there are errors in the network and console tabs, take some screenshots and send it to me.

Customer changed the ui-source parameter to external and the webpage got inaccessible.

Then it was recommended to change the ui parameter back to auto through the command line.

```
kubectl edit settings ui-source
```

![image](https://user-images.githubusercontent.com/113181949/207863292-485efb50-4201-4229-b602-73663494faaf.png)





