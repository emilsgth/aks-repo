# ----------- Resources for Deployment ------------

# There is also in variables.tf file the description option in every variable where you can find explainations.


# Azure Client Config
data "azurerm_client_config" "current" {}

# Existing Azure Resource Group
resource "azurerm_resource_group" "aks" {
  name = var.resource_group_name
  location            = var.location
}


# Create Azure Kubernetes Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location

  # Specifies the Resource Group where the Managed Kubernetes Cluster should exist
  resource_group_name = azurerm_resource_group.aks.name
 
  # DNS prefix specified when creating the managed cluster
  dns_prefix          = var.dns_prefix
  
  # Prevent the resources to be deleted if you run more than 1 time the apply command
  lifecycle {
    prevent_destroy = false
  }

  linux_profile {
    # List of additional node pools to the cluster
    admin_username = var.admin_username

    ssh_key {
      key_data = file("~/.ssh/id_rsa.pub")
    }
  
 }

# List of additional node pools to the cluster
  dynamic "default_node_pool" {
    for_each = var.agent_pools
    content {
      name       = default_node_pool.value.name
      node_count = default_node_pool.value.count
      vm_size    = default_node_pool.value.vm_size
      os_disk_size_gb     = default_node_pool.value.os_disk_size_gb
      type                = "VirtualMachineScaleSets"
      enable_auto_scaling = default_node_pool.value.enable_auto_scaling
      min_count           = default_node_pool.value.min_count
      max_count           = default_node_pool.value.max_count
      max_pods            = default_node_pool.value.max_pods
      tags = var.tags

      vnet_subnet_id = azurerm_subnet.aks.id
    }
  }
  node_resource_group = var.node_resource_group_name
  
  kubernetes_version = "1.17.13"
  
  # Addon profile is used for monitoring 
  addon_profile {
    http_application_routing {
      enabled = false
    }
  }

  # Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located
  private_cluster_enabled = false

  service_principal {
    # The Client ID for the Service Principal
    client_id     = azuread_service_principal.sp.application_id

    #  The Client Secret for the Service Principal
    client_secret = azuread_service_principal_password.sp.value  
  }

  # Is Role Based Access Control Enabled
  role_based_access_control {
    enabled = true

  }
  network_profile {
    network_plugin     = var.network_plugin
    load_balancer_sku  = var.load_balancer_sku

    # The Network Range used by the Kubernetes service
    service_cidr       = var.service_cidr

    # IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns)
    dns_service_ip     = var.dns_service_ip

    # The Network Range used by the Kubernetes service
    docker_bridge_cidr = var.docker_bridge_cidr
    network_policy     = var.network_policy
  }
      tags = var.tags
}

