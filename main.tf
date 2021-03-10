
module "ask" {
    source = "./module"
    
    resource_group_name = "CLUSTER-RG"
    network_plugin = "kubenet"
    load_balancer_sku = "Basic"
    service_cidr = "10.0.0.0/16"
    dns_service_ip = "10.0.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    network_policy = "calico"
    agent_count = 2
    admin_username = "vm-user"
    dns_prefix = "aks-dns-name"
    cluster_name = "ask-name"
    location = "East US"

# Agent pools values
agent_pools = [{
    name                = "pool1"
    count               = 1
    vm_size             = "Standard_D2s_v3"
    os_disk_size_gb     = 30
    max_pods            = 30
    enable_auto_scaling = true
    min_count           = 1
    max_count           = 3
  }]
# -------------------------

# Resource group for the node resources
node_resource_group_name = "aks-node-rg"
# -------------------------

# Tags
tags = {
        EnvType        = "Non-Production"
        SenType        = "Not Applicable"
        Deployer       = "Llazar Gjermeni"
        DeployDate     = "03-09-202`"
        DeptName       = "Aks Delivery"
        Sensitivity    = "Non-Sensitive"
        Department     = "Kubernetes"

      }
}

module "storage" {
  source = "./storage"

  name = "straccmod"

  resource_group_name = "storage-rg"

  kind = "FileStorage"

  shares = [
    {
      name  = "example"
      quota = 5120
    }
  ]
}
