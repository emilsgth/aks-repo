output "aks_kube_config_raw" {
  description = "Raw kube config to be used by kubectl command"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "client_key" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.client_key
}

output "client_certificate" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate
}

output "cluster_username" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.username
}

output "kube_config" {
    value = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "host" {
    value = azurerm_kubernetes_cluster.aks.kube_config.0.host
}