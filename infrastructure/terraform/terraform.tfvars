## Configuration file for Azure ##

# Azure resource group configuration
resource_group_name = "mezcloud.com-rg"
resource_group_location = "westus2"

# Azure VM admin username
admin_username = "houddinii"

# Azure VM size
vm_size = "Standard_B2s_v2"

# Azure VM OS disk Configuration
os_disk_name = "mezcloud-osdisk" # Azure VM OS disk name
os_disk_type = "Standard_LRS" # Azure VM OS disk type
disk_size_gb = 35 # Azure VM OS disk size in GB

# Azure VM os profile configuration
# azure vm os sku
os_sku = "18.04-LTS" # Ubuntu 18.04 LTS

# path to ssh public key
ssh_private_key_path = "~/mezcloud.com/infrastructure/ansible/ansible_ssh_key"
