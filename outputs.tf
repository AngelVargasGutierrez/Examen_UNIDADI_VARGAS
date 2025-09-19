# Outputs de la infraestructura de Movies Analytics

output "resource_group" {
  description = "Información del grupo de recursos"
  value = {
    name     = azurerm_resource_group.main.name
    location = azurerm_resource_group.main.location
    id       = azurerm_resource_group.main.id
  }
}

output "sql_server" {
  description = "Información del servidor SQL"
  value = {
    name                          = azurerm_mssql_server.main.name
    fully_qualified_domain_name   = azurerm_mssql_server.main.fully_qualified_domain_name
    administrator_login           = azurerm_mssql_server.main.administrator_login
    version                       = azurerm_mssql_server.main.version
  }
  sensitive = false
}

output "database" {
  description = "Información de la base de datos"
  value = {
    name        = azurerm_mssql_database.movies.name
    id          = azurerm_mssql_database.movies.id
    collation   = azurerm_mssql_database.movies.collation
    max_size_gb = azurerm_mssql_database.movies.max_size_gb
    sku_name    = azurerm_mssql_database.movies.sku_name
  }
}

output "storage_account" {
  description = "Información de la cuenta de almacenamiento"
  value = {
    name                     = azurerm_storage_account.main.name
    primary_blob_endpoint    = azurerm_storage_account.main.primary_blob_endpoint
    primary_access_key       = azurerm_storage_account.main.primary_access_key
    account_tier            = azurerm_storage_account.main.account_tier
    account_replication_type = azurerm_storage_account.main.account_replication_type
  }
  sensitive = true
}

output "storage_containers" {
  description = "Información de los contenedores de almacenamiento"
  value = {
    csv_files = {
      name = azurerm_storage_container.csv_files.name
      url  = "${azurerm_storage_account.main.primary_blob_endpoint}${azurerm_storage_container.csv_files.name}"
    }
    scripts = {
      name = azurerm_storage_container.scripts.name
      url  = "${azurerm_storage_account.main.primary_blob_endpoint}${azurerm_storage_container.scripts.name}"
    }
  }
}

output "data_factory" {
  description = "Información del Data Factory"
  value = {
    name = azurerm_data_factory.main.name
    id   = azurerm_data_factory.main.id
  }
}

output "key_vault" {
  description = "Información del Key Vault"
  value = {
    name       = azurerm_key_vault.main.name
    vault_uri  = azurerm_key_vault.main.vault_uri
    id         = azurerm_key_vault.main.id
  }
}

output "powerbi_embedded" {
  description = "Información de Power BI Embedded"
  value = {
    name = azurerm_powerbi_embedded.main.name
    id   = azurerm_powerbi_embedded.main.id
    sku  = azurerm_powerbi_embedded.main.sku
  }
}

output "connection_strings" {
  description = "Cadenas de conexión para las aplicaciones"
  value = {
    sql_server = "Server=tcp:${azurerm_mssql_server.main.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.movies.name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    storage    = "DefaultEndpointsProtocol=https;AccountName=${azurerm_storage_account.main.name};AccountKey=${azurerm_storage_account.main.primary_access_key};EndpointSuffix=core.windows.net"
  }
  sensitive = true
}

output "deployment_info" {
  description = "Información general del despliegue"
  value = {
    environment           = var.environment
    project_name         = var.project_name
    deployment_timestamp = timestamp()
    terraform_version    = "~> 1.0"
    provider_version     = "~> 3.0"
  }
}

output "endpoints" {
  description = "Endpoints importantes de la infraestructura"
  value = {
    sql_server_endpoint    = azurerm_mssql_server.main.fully_qualified_domain_name
    storage_blob_endpoint  = azurerm_storage_account.main.primary_blob_endpoint
    key_vault_uri         = azurerm_key_vault.main.vault_uri
    data_factory_endpoint = "https://${azurerm_data_factory.main.name}.datafactory.azure.com"
  }
}

output "resource_ids" {
  description = "IDs de recursos para referencia en otros módulos"
  value = {
    resource_group_id    = azurerm_resource_group.main.id
    sql_server_id       = azurerm_mssql_server.main.id
    database_id         = azurerm_mssql_database.movies.id
    storage_account_id  = azurerm_storage_account.main.id
    data_factory_id     = azurerm_data_factory.main.id
    key_vault_id        = azurerm_key_vault.main.id
    powerbi_embedded_id = azurerm_powerbi_embedded.main.id
  }
}