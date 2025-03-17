# Cloud Init Example

```
#cloud-config
disable_root: false
packages:
  - vim
  - sudo
  - epel-release
  - bind-utils
  - qemu-guest-agent
runcmd:
  - - sysctl
    - -w
    - net.ipv6.conf.all.disable_ipv6=1
ssh_pwauth: True
users:
  - name: root
    hashed_passwd: <create a hashed password>
    lock_passwd: false
  - name: linux
    groups: [ sudo ]
    hashed_passwd: <create a hashed password>
    lock_passwd: false
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - <past your ssh key here>
```