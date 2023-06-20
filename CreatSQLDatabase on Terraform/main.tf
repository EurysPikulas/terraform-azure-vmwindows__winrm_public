
# Serveur SQL
resource "azurerm_sql_server" "server1" {
  name                         = var.server1_name
  resource_group_name          = data.azurerm_resource_group.rgName.name
  location                     = var.locationNE
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password
}


# Base de données SQL
resource "azurerm_sql_database" "db" {
  name                = var.database_name
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  server_name         = data.azurerm_sql_server.example.name
  edition             = "GeneralPurpose"
  family              = "Gen5"
  capacity            = 2
  zone_redundant      = false
}

