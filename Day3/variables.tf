variable "resource_group" {

    description = "resource group configuration"
    type = object({
        name     = string
        location = string
    })
}

variable "tags" {

    description = "Common tags for all resources"
    type = map(string)  
  
}

variable "admin_username" {

    description = "Admin username for virtual machines"
    type        = string
  
}

variable "vm_config" {

    description = "Linux VM configuration"

    type = object({
        name              = string
        size              = string
        os_disk_size_gb   = number
        enable_public_ip    = bool
    })
}

variable "allowed_ports" {

    description = "Inbound ports to allow on NSG"

    type = set(number)
  
}

