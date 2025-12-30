# ---HARVESTER---

variable "harvester_kubeconfig" {
  description = "path to the kubeconfig file to access Harvester"
  type        = string
  default     = "default"
}

# ---VM SETTINGS---

variable "vm_name" {
  description = "Virtual Machine Name"
  type        = string
  default     = "vm-s3bucket"
}

variable "namespace" {
  description = "Namespace where the VM will be created"
  type        = string
  default     = "default"
}

variable "network_name" {
  description = "Nome da VM Network no Harvester"
  type        = string
  default     = "vmnet"
}

variable "vm_user" {
  description = "Usuário padrão da VM"
  type        = string
  default     = "tux"
}

variable "vm_password" {
  description = "Senha do usuário (opcional se usar SSH Key)"
  type        = string
  default     = "Secret.Password123"
}

variable "ssh_public_key" {
  description = "Sua chave pública SSH (conteúdo de id_rsa.pub)"
  type        = string
}

variable "vm_ip_address" {
  description = "VM Static IP Address (192.168.1.10/24)"
  type        = string
}

variable "vm_gateway" {
  description = "VM Static IP Address (192.168.1.1)"
  type        = string
}

# ---GARAGE S3 BUCKET---

variable "bucket_region" {
  description = "S3 Bucket Region"
  type        = string
}

variable "bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "garage_version" {
  description = "Garage Version"
  type        = string
}