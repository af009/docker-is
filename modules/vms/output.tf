output "vm_password" {
  value = var.admin_password
}
output "vm_username" {
  value = var.admin_username
}
output "public_key" {
  value = azurerm_linux_virtual_machine.vms.admin_ssh_key
}
