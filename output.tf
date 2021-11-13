output "administrator-password-pg" {
  value     = module.postgresql.administrator-password
  sensitive = true
}
output "administrator-pg" {
  value = module.postgresql.administrator
}
output "server_db" {
  value = module.postgresql.server_db
}
#output "vm-password" {
#  value = module.vms-1.vm_password
#}
output "vm-username" {
  value = module.vms-1.vm_username
}
output "vm_public_key" {
  value = module.vms-1.public_key
}
