# Configuración del proveedor de Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-prod"
    storage_account_name = "stterraformstateproda"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Grupo de recursos
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Development"
    Project     = "Movies Analytics"
  }
}

# SQL Server
resource "azurerm_mssql_server" "main" {
  name                         = "sql-movies-${random_string.suffix.result}"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  tags = {
    Environment = "Development"
    Project     = "Movies Analytics"
  }
}

# Regla de firewall para permitir servicios de Azure
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Regla de firewall para permitir acceso desde cualquier IP (solo para desarrollo)
resource "azurerm_mssql_firewall_rule" "allow_all" {
  name             = "AllowAll"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

# Base de datos SQL
resource "azurerm_mssql_database" "movies" {
  name           = "movies-db"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "Basic"

  tags = {
    Environment = "Development"
    Project     = "Movies Analytics"
  }
}

# Storage Account para almacenar archivos CSV y scripts
resource "azurerm_storage_account" "main" {
  name                     = "stmovies${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = "Development"
    Project     = "Movies Analytics"
  }
}

# Container para archivos CSV
resource "azurerm_storage_container" "csv_files" {
  name                  = "csv-files"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Container para scripts
resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Azure Data Factory para ETL
resource "azurerm_data_factory" "main" {
  name                = "adf-movies-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    Environment = "Development"
    Project     = "Movies Analytics"
  }
}

# Key Vault para almacenar secretos
resource "azurerm_key_vault" "main" {
  name                = "kv-movies-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore"
    ]
  }

  tags = {
    Environment = "Development"
    Project     = "Movies Analytics"
  }
}

# Secreto para la cadena de conexión de la base de datos
resource "azurerm_key_vault_secret" "db_connection_string" {
  name         = "db-connection-string"
  value        = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.movies.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  key_vault_id = azurerm_key_vault.main.id
}

# Power BI Workspace (usando REST API a través de null_resource)
resource "azurerm_powerbi_embedded" "main" {
  name                = "pbi-movies-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "A1"
  administrators      = [data.azurerm_client_config.current.object_id]

  tags = {
    Environment = "Development"
    Project     = "Movies Analytics"
  }
}

# Generador de cadena aleatoria para nombres únicos
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Datos del cliente actual
data "azurerm_client_config" "current" {}

# Outputs
output "sql_server_fqdn" {
  description = "FQDN del servidor SQL"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "database_name" {
  description = "Nombre de la base de datos"
  value       = azurerm_mssql_database.movies.name
}

output "storage_account_name" {
  description = "Nombre de la cuenta de almacenamiento"
  value       = azurerm_storage_account.main.name
}

output "data_factory_name" {
  description = "Nombre del Data Factory"
  value       = azurerm_data_factory.main.name
}

output "key_vault_name" {
  description = "Nombre del Key Vault"
  value       = azurerm_key_vault.main.name
}

output "powerbi_embedded_name" {
  description = "Nombre del Power BI Embedded"
  value       = azurerm_powerbi_embedded.main.name
}

output "resource_group_name" {
  description = "Nombre del grupo de recursos"
  value       = azurerm_resource_group.main.name
}