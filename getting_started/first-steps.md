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

3. [Harvester Training](#harvester-training)
4. [Live Migration and Redundancy](#live-migration-and-redundancy)
5. [Change UI settings through CLI](#change-ui-settings-through-cli)

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


#### explanation: 
This is not supported in the current stage, and I don't think Harvester should play the role of auto-pilot, for some cases, the admin would prefer to fix the network issues manually, or sometimes, there are VMs that can't be migrated to the other node and should be kept on the existing one, IMO the preferred path should be
 - configure related monitoring and alerts and send notification to the system admins.
 - enable the node maintenance mode e.g., via calling the API or some custom automation tools/script, then the VMs will be migrated to the other node accordingly.


Change UI settings through CLI
===============================

#### Case issue: Customer cannot create a new storage class because the fileds in the parameters tab to configure the new storage class.

![storage_class](https://user-images.githubusercontent.com/113181949/207861795-402b33a3-b93a-44bd-9620-19c106cc0960.JPG)

### Case Resolution:

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





