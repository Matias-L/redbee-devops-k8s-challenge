############################################
# Resource group variables ####
############################################

variable "rg_name"{
    type = string
    description = "Name of the resource group where k8s cluster will be deployed"
    default = "k8s-rg"

}

variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}



############################################
# Container registry variables ####
############################################

variable "acr_name" {
  default="defaultacr"
}

variable "acr_sku" {
  default="Premium"
}

############################################
# General K8S variables
############################################

variable "cluster_name" {
    description = "Name of the k8s cluster"
  default = "k8stest"
}

variable "dns_prefix" {
    description = "(Optional) DNS prefix specified when creating the managed cluster"
  default = "k8stest"
}

############################################
# K8S node pool config
############################################

variable "default_node_pool_name" {
    description = "(Required) The name which should be used for the default Kubernetes Node Pool."
  default = "agentpool"
}


variable "default_node_pool_vm_size" {
        description = "(Required) The size of the Virtual Machine, such as Standard_DS2_v2"
  default = "Standard_B2s"
  
}

variable "agent_count" {
    description = "(Optional) The initial number of nodes which should exist in this Node Pool."
    default = 1
}


variable "agent_min_count" {
    description = "(Optional) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
    default = 1
}


variable "agent_max_count" {
    description = "(Optional) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000."
    default = 1
}







############################################
# K8S identity (service principal)
############################################

# The following two variable declarations are placeholder references.
# Set the values for these variable in terraform.tfvars
# Reference https://learn.microsoft.com/es-es/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal
variable "aks_service_principal_app_id" {
  default = ""
}

variable "aks_service_principal_client_secret" {
  default = ""
}







# variable "resource_group_name_prefix" {
#   default     = "rg"
#   description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
# }

# variable "ssh_public_key" {
#   default = "~/.ssh/id_rsa.pub"
# }

