# Output for Ansible inventory file

# Output the public IP address of the VM
output "public_ip_address" {
  value = data.azurerm_public_ip.vm_public_ip.ip_address
}

# Output the SSH private key in case you need it
output "ssh_private_key" {
  value     = local.private_key_pem
  sensitive = true
}

output "ssh_private_key_path" {
  description = "Path to the SSH private key file"
  value       = local.private_key_path
}

# Output the SSH command to connect to the VM
output "ssh_command" {
  value = "ssh -i ${local.private_key_path} ${var.admin_username}@${data.azurerm_public_ip.vm_public_ip.ip_address}"
}

# Pass the SSH private key to Ansible
resource "local_file" "ansible_ssh_key" {
  content  = local.private_key_pem
  filename = "${path.module}/../ansible/ansible_ssh_key"  # Update the path to store the SSH key in the correct location
}



