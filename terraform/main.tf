resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.rg_name
}


# Reference https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry#:~:text=existing.id%0A%7D-,Example%20Usage%20(Attaching%20a%20Container%20Registry%20to%20a%20Kubernetes%20Cluster),-resource%20%22azurerm_resource_group%22
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.acr_sku

}


resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
 
  default_node_pool {
    name       = var.default_node_pool_name
    vm_size    = var.default_node_pool_vm_size
    node_count = var.agent_count
    min_count = var.agent_min_count
    max_count = var.agent_max_count
  }
  # linux_profile {
  #   admin_username = "ubuntu"

  #   ssh_key {
  #     key_data = file(var.ssh_public_key)
  #   }
  # }
  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  # service_principal {
  #   client_id     = var.aks_service_principal_app_id
  #   client_secret = var.aks_service_principal_client_secret
  # }

 tags = {
    Environment = "Development"
    Terraform = "true"
  }

}

# Role for K8S connection with ACR

    data "azurerm_container_registry" "acr_name" {
      name = var.acr_name
      resource_group_name = azurerm_resource_group.rg.name
    }

resource "azurerm_role_assignment" "k8s_acr_role_assignment" {
  scope                = data.azurerm_container_registry.acr_name.id
  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  skip_service_principal_aad_check = true
}