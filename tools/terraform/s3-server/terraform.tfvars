# ---HARVESTER---
harvester_kubeconfig = "~/.kube/config"

# ---VM SETTINGS---
namespace            = "garage"
vm_name              = "vm-s3bucket"
network_name         = "vmnet"
vm_user              = "opensuse"
vm_password          = "$6$xyz$NrQsvY4ClU6g8vwP2hc5oF.ul0M.j0QDVl3qBe.LeHNUYNbQszQfu.OH.7gyLhfNIJeqHdRYkCvh40Qmz8sR00"
ssh_public_key       = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFAhgIKk9L4pXM14pzvoICFNt+OY2HETqFRz4VcsZHwb rodolfo.almeida@suse.com"
vm_ip_address        = "192.168.10.252"
vm_gateway           = "192.168.10.1"

# ---GARAGE S3 BUCKET---
garage_version       = "https://garagehq.deuxfleurs.fr/_releases/v2.1.0/x86_64-unknown-linux-musl/garage"
bucket_region        = "north1"
bucket_name          = "bucket1"
