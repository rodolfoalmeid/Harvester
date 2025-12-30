version: 2
ethernets:
  eth0:
    dhcp4: false
    addresses:
      - ${vm_ip_address}
    gateway4: ${vm_gateway}
    nameservers:
      search: [lab.suse.local]
      addresses:
        - 8.8.8.8
        - 1.1.1.1