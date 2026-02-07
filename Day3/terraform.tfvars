resource_group = {
  name = "rg-terraform-demo"
  location = "eastus"
}

tags = {
  env = "dev"
  owner = "vitthal"
}

admin_username = "azureadmin"

vm_config = {
  name = "vm-terraform-demo"
  size = "Standard_B2s"
  os_disk_size_gb = 30
  enable_public_ip = true
}

allowed_ports = [ 22, 80, 443 ]
