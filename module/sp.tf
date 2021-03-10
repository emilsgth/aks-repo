# Create Azure Active Directory app
resource "azuread_application" "sp" {
  display_name               = var.sp_name
  identifier_uris            = ["http://${var.sp_name}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

# Create Service Principal
resource "azuread_service_principal" "sp" {
  application_id = azuread_application.sp.application_id
}

# Random string
resource "random_string" "unique" {
  length  = 32
  special = false
  upper   = true

  keepers = {
    service_principal = azuread_service_principal.sp.id
  }
}

# Service Principal password
resource "azuread_service_principal_password" "sp" {
  service_principal_id = azuread_service_principal.sp.id
  value                = random_string.unique.result
  end_date             = var.end_date
}

# Role Assignment for the networking
resource "azurerm_role_assignment" "role_assignment_network" {
  scope                = azurerm_subnet.aks.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.id
}

# Role Assignment for the aks
resource "azurerm_role_assignment" "role_assignment_aks" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.id
}
