provider "azurerm" {
  features {}
  client_id       = "8a72e526-9786-4b0b-8cf3-3f1ed422e175"   # Replace with your appId
  client_secret   = "zAH8Q~5zo9cwsVDpiiot1SkGA3GuuKBa55RFJcEP"   # Replace with your password
  subscription_id = "c6041c63-c198-4a7e-8556-457e3ba0082f"   # Replace with your Azure subscription ID
  tenant_id      = "379cd54f-14dc-4d2c-95a2-cdf3a51d30fb"   # Replace with your tenant
}

# Define the Azure Resource Group
resource "azurerm_resource_group" "mezcloud_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Generate SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save the private key to a local file with 600 permissions
resource "local_file" "private_key" {
  filename = "${path.module}/private_key.pem"
  content  = tls_private_key.ssh_key.private_key_pem
  file_permission = "600"
}

# Store the private key path in a local variable
locals {
  private_key_pem  = tls_private_key.ssh_key.private_key_pem
  private_key_path = local_file.private_key.filename
}

# Define the Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "mezcloud-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mezcloud_rg.location
  resource_group_name = azurerm_resource_group.mezcloud_rg.name
}

# Define the Subnet within the Virtual Network
resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.mezcloud_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define the Network Security Group (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "mezcloud-nsg"
  location            = azurerm_resource_group.mezcloud_rg.location
  resource_group_name = azurerm_resource_group.mezcloud_rg.name
}

# Define a network security rule for allowing HTTP traffic
resource "azurerm_network_security_rule" "http_rule" {
  name                        = "http-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.mezcloud_rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Define the Public IP Address
resource "azurerm_public_ip" "public_ip" {
  name                = "mezcloud-public-ip"
  location            = azurerm_resource_group.mezcloud_rg.location
  resource_group_name = azurerm_resource_group.mezcloud_rg.name
  allocation_method   = "Dynamic"
}

# Define the Network Interface Card (NIC)
resource "azurerm_network_interface" "nic" {
  name                = "mezcloud-nic"
  location            = azurerm_resource_group.mezcloud_rg.location
  resource_group_name = azurerm_resource_group.mezcloud_rg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.public_ip.id
  }
}

# Define the virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = "mezcloud-vm"
  location              = azurerm_resource_group.mezcloud_rg.location
  resource_group_name   = azurerm_resource_group.mezcloud_rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size  # Updated VM size in cofig.tfvars

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = var.os_sku  # Updated OS SKU in cofig.tfvars
    version   = "latest"
  }

  storage_os_disk {
  name              = var.os_disk_name # Updated disk name in cofig.tfvars
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = var.os_disk_type  # Specify Standard HDD type here
  }

  os_profile {
    computer_name  = "mezcloud-vm"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    # Configure SSH key directly on the VM
    ssh_keys {
      key_data = tls_private_key.ssh_key.public_key_openssh
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }

  tags = {
    environment = "development"
  }
}

# Data source to retrieve the public IP address
data "azurerm_public_ip" "vm_public_ip" {
  name                = azurerm_public_ip.public_ip.name
  resource_group_name = azurerm_public_ip.public_ip.resource_group_name
}

# Define a null_resource to trigger Ansible playbook execution
resource "null_resource" "run_ansible" {
  triggers = {
    # Use the virtual machine's ID as a trigger, so Ansible runs after VM creation.
    instance_id = azurerm_virtual_machine.vm.id
  }
  
  provisioner "local-exec" {
    # Specify the commands to set SSH key permissions and run your Ansible playbook; define the logfile creation & change permissions to 600.
    command = "yes | chmod 600 ../ansible/ansible_ssh_key && chmod 600 ../ansible/inventory.ini && chmod 600 ../ansible/install_docker.yml && ansible-playbook -i ../ansible/inventory.ini ../ansible/install_docker.yml && echo \"$(date -u '+%Y-%m-%dT%H:%M:%SZ') 0\" >> ../ansible/ansible_log.txt || echo \"$(date -u '+%Y-%m-%dT%H:%M:%SZ') 1\" >> ../ansible/ansible_log.txt"
    interpreter = ["sh", "-c"]
  }

  # Ensure the Ansible playbook runs after the VM creation
  depends_on = [azurerm_virtual_machine.vm]
}


# Create an Ansible inventory file and give it the necessary permission 600
resource "local_file" "ansible_inventory" {
  content = <<EOF
[mezcloud]
${data.azurerm_public_ip.vm_public_ip.ip_address} ansible_user=${var.admin_username} ansible_ssh_private_key_file=../ansible/ansible_ssh_key
EOF

  filename = "${path.module}/../ansible/inventory.ini"
  file_permission = "600"
}

