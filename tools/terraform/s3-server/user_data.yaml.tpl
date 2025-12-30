#cloud-config
disable_root: false
package_update: true
packages:
  - vim
  - sudo
  - bind-utils
  - qemu-guest-agent
  - iptables
  - chrony
  - wget
  - openssl
ssh_pwauth: True
users:
  - name: ${vm_user}
    groups: [ sudo ]
    hashed_passwd: ${vm_password}
    lock_passwd: false
    shell: /bin/bash
    sudo: ALL=(ALL) NOPASSWD:ALL
    ssh_authorized_keys:
      - ${ssh_public_key}
runcmd:
  - systemctl enable --now qemu-guest-agent.service
  - sysctl -w net.ipv6.conf.all.disable_ipv6=1
  - "sleep 60 && bash /opt/setup.sh > /var/log/setup-debug.log 2>&1"
write_files:
  - path: /opt/setup.sh
    permissions: '0755'
    encoding: b64
    content: ${script_content}

