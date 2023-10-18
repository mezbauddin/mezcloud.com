#Azure Virtual Machine
# azure vm admin username

# azure resource group name
variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
  default     = "mezcloud-rg" # Set a default value or leave it empty if you prefer
}

# resource group location
variable "resource_group_location" {
  description = "The location of the Azure resource group"
  type        = string
  default     = "westus2" # Set a default value or leave it empty if you prefer
}

# vnet name
variable "vnet_name" {
  description = "The name of the Azure VNet"
  type        = string
  default     = "mezcloud-vnet" # Set a default value or leave it empty if you prefer
}

# NSG name
variable "nsg_name" {
  description = "NSG name of the resource group"
}

# Vm admin user name
variable "admin_username" {
  description = "The admin username for the Azure VM"
  type        = string
  default     = "vm-admin" # Set a default value or leave it empty if you prefer
}

# azure vm size
variable "vm_size" {
  description = "The size of the Azure VM"
  type        = string
  default     = "Standard_B2s_v2" # Set a default value or leave it empty if you prefer
}

# azure vm os disk name
variable "os_disk_name" {
  description = "The name of the Azure VM OS disk"
  type        = string
  default     = "osdisk" # Set a default value or leave it empty if you prefer
}

# azure vm os disk type
variable "os_disk_type" {
  description = "The type of the Azure VM disk"
  type        = string
  default     = "StandardSSD_LRS" # Set a default value or leave it empty if you prefer
}


# ssh private key path
variable "ssh_private_key_path" {
  description = "The path to the private key used to connect to the Azure VM"
  type        = string
  default     = "~/mezcloud.com/infrastructure/ansible/ansible_ssh_key" # Set a default value or leave it empty if you prefer
}