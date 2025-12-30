# --- PROVIDER ---
provider "harvester" {
  kubeconfig = var.harvester_kubeconfig 
}

provider "kubernetes" {
  config_path    = var.harvester_kubeconfig 
}

resource "kubernetes_namespace_v1" "vm_namespace" {
  metadata {
    name = var.namespace
  }
}

# --- DATA SOURCES ---

data "harvester_clusternetwork" "mgmt" {
  name = "mgmt" 
}

# --- RESOURCES ---

resource "harvester_ssh_key" "myssh" {
  name       = "terraform-ssh-key"
  namespace  = kubernetes_namespace_v1.vm_namespace.metadata[0].name
  public_key = var.ssh_public_key
}

resource "harvester_image" "opensuse156" {
  name         = "opensuse156"
  namespace    = kubernetes_namespace_v1.vm_namespace.metadata[0].name
  display_name = "openSUSE-Leap-15.6"
  source_type  = "download"
  url          = "https://download.opensuse.org/repositories/Cloud:/Images:/Leap_15.6/images/openSUSE-Leap-15.6.x86_64-NoCloud.qcow2"
}

resource "harvester_cloudinit_secret" "cloud_config_user" {
  name      = "cloudinit-user-secret"
  namespace = kubernetes_namespace_v1.vm_namespace.metadata[0].name

  user_data = templatefile("${path.module}/user_data.yaml.tpl", {
    vm_user        = var.vm_user
    vm_password    = var.vm_password
    ssh_public_key = var.ssh_public_key
    script_content = base64encode(templatefile("${path.module}/setup.sh.tpl", {
        srv_ip         = var.vm_ip_address
        bucket_name    = var.bucket_name
        bucket_region  = var.bucket_region
        garage_version = var.garage_version
    }))
  })
}

resource "harvester_cloudinit_secret" "cloud_config_net" {
  name      = "cloudinit-net-secret"
  namespace = kubernetes_namespace_v1.vm_namespace.metadata[0].name

  network_data = templatefile("${path.module}/network_data.yaml.tpl", {
    vm_ip_address = var.vm_ip_address
    vm_gateway    = var.vm_gateway
  })
}

# Create Network Name
resource "harvester_network" "mgmt-vmnet" {
  name      = var.network_name
  namespace = kubernetes_namespace_v1.vm_namespace.metadata[0].name
  vlan_id = 0
  cluster_network_name = data.harvester_clusternetwork.mgmt.name
}

# 4. VM Settings
resource "harvester_virtualmachine" "vm-demo" {
  name                 = var.vm_name
  namespace            = kubernetes_namespace_v1.vm_namespace.metadata[0].name
  description          = "S3 Bucket VM created"
  cpu                  = 4
  memory               = "6Gi"
  run_strategy         = "Always"

  network_interface {
    name         = "eth0"
    network_name = harvester_network.mgmt-vmnet.id 
    model        = "virtio"
  }

  disk {
    name        = "rootdisk"
    type        = "disk"
    size        = "100Gi"
    bus         = "virtio"
    boot_order  = 1
    auto_delete = true
    image       = harvester_image.opensuse156.id 
  }

  cloudinit {
    user_data_secret_name    = harvester_cloudinit_secret.cloud_config_user.name
    network_data_secret_name = harvester_cloudinit_secret.cloud_config_net.name
  }
}