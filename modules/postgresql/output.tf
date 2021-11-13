output "administrator-password" {
  value = azurerm_postgresql_server.postgres-server.administrator_login_password
}
output "administrator" {
  value = azurerm_postgresql_server.postgres-server.administrator_login
}
output "server_db" {
  value = azurerm_postgresql_server.postgres-server.name
}
