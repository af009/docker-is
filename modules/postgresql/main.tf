# Create a random string to generate a unique name
resource "random_string" "name" {
  length  = 12
  special = false
  upper   = false
}

# Create a postgres server
resource "azurerm_postgresql_server" "postgres-server" {
  location            = var.location
  name                = "postgres-db-${random_string.name.result}"
  resource_group_name = var.resource_group_name
  sku_name            = "B_Gen5_2"
  version             = "11"
  storage_mb          = 5120

  administrator_login           = var.PGUSERNAME
  administrator_login_password  = var.PGPASSWORD
  ssl_enforcement_enabled       = false
  auto_grow_enabled             = false
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = true

}

#Create Postgres firewall rule 1 - app ip
resource "azurerm_postgresql_firewall_rule" "postgres_firewall-app-ip" {
  name                = "app"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres-server.name
  start_ip_address    = var.public_ip
  end_ip_address      = var.public_ip
}

#Create Postgres firewall rule 2 - local ip
resource "azurerm_postgresql_firewall_rule" "postgres_firewall-local-ip" {
  name                = "local"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres-server.name
  start_ip_address    = var.local_ip
  end_ip_address      = var.local_ip
}

# Allow Azure services and resources
resource "azurerm_postgresql_firewall_rule" "test" {
  name                = "psql-azure-services-test"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres-server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
