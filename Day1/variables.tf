variable "resource_group_name" {
    description = "The name of the Azure Resource Group."
    type        = string
}

variable "location" {
    description = "The Azure region where resources will be created."
    type        = string
    default     = "East US"
}

variable "storage_account_name" {
    description = "Globally unique storage account name"
    type        = string
}

variable "environment" {
    description = "Environment tag"
    type        = string
    default     = "dev"
}