Is there a way to limit the number of Virtual Machines (VMs) that can be created within a single project on Harvester. The context for this request is that they have a limited amount of IP addresses in their subnets. As these clusters are shared by multiple customers, there’s a risk of IP addresses being consumed without any control, leading to potential network issues.

Background: limiting pods within Terraform project definitions, but this approach was unsuitable for their needs. The limitation on pods also restricts hot-plug volumes, as these are also considered pods within the project, rendering the solution unfit for production use.

Proposed Solution: To address this, the following steps were taken:

#### 1- A namespace called virtualmachines was created.

#### 2- A resource quota was defined as follows:
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: vm-quota
  namespace: virtualmachines
spec:
  hard:
    count/virtualmachines.kubevirt.io: "5"  # limit to 5 VMs 
```

#### 3- Creation of VMs was tested, and the kubectl get resourcequota command confirmed that the VM count increased as expected.
```bash
╰$ k get resourcequota -n virtualmachines
NAMESPACE         NAME       AGE     REQUEST                                  LIMIT
virtualmachines   vm-quota   9m26s   count/virtualmachines.kubevirt.io: 5/5   
```

#### 4- Upon attempting to create a 6th VM, an error was correctly triggered, indicating that the quota had been exceeded.

```bash
Error Message:

virtualmachines.kubevirt.io "vm-rq-test" is forbidden: exceeded quota: vm-quota, requested: count/virtualmachines.kubevirt.io=1, used: count/virtualmachines.kubevirt.io=5, limited: count/virtualmachines.kubevirt.io=5 
```

The customer has requested that this quota functionality be supported and maintained via the Terraform provider, similar to how other quota-related values are managed. They currently use the Rancher2 Terraform provider for project management but have noted that VM quotas are not currently supported.