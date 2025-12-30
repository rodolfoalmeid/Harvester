terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = ">= 1.7.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 3.0.1"
    }
  }
}