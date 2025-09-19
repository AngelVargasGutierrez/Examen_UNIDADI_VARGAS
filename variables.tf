# Variables para la infraestructura de Movies Analytics

variable "resource_group_name" {
  description = "Nombre del grupo de recursos de Azure"
  type        = string
  default     = "rg-movies-analytics"
  
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "El nombre del grupo de recursos no puede estar vacío."
  }
}

variable "location" {
  description = "Región de Azure donde se desplegarán los recursos"
  type        = string
  default     = "East US"
  
  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US", "West Central US",
      "Canada Central", "Canada East", "Brazil South", "North Europe", "West Europe",
      "UK South", "UK West", "France Central", "Germany West Central",
      "Switzerland North", "Norway East", "Sweden Central", "Poland Central",
      "Italy North", "Spain Central", "Israel Central", "UAE North",
      "South Africa North", "Australia East", "Australia Southeast",
      "Australia Central", "Australia Central 2", "East Asia", "Southeast Asia",
      "Japan East", "Japan West", "Korea Central", "Korea South",
      "Central India", "South India", "West India", "Jio India West"
    ], var.location)
    error_message = "La ubicación debe ser una región válida de Azure."
  }
}

variable "sql_admin_username" {
  description = "Nombre de usuario del administrador de SQL Server"
  type        = string
  default     = "sqladmin"
  
  validation {
    condition     = length(var.sql_admin_username) >= 4 && length(var.sql_admin_username) <= 128
    error_message = "El nombre de usuario debe tener entre 4 y 128 caracteres."
  }
}

variable "sql_admin_password" {
  description = "Contraseña del administrador de SQL Server"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd123!"
  
  validation {
    condition = length(var.sql_admin_password) >= 8 && length(var.sql_admin_password) <= 128 && 
                can(regex("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]+$", var.sql_admin_password))
    error_message = "La contraseña debe tener entre 8 y 128 caracteres e incluir al menos una letra minúscula, una mayúscula, un número y un carácter especial."
  }
}

variable "database_sku" {
  description = "SKU de la base de datos SQL"
  type        = string
  default     = "Basic"
  
  validation {
    condition = contains([
      "Basic", "S0", "S1", "S2", "S3", "S4", "S6", "S7", "S9", "S12",
      "P1", "P2", "P4", "P6", "P11", "P15", "GP_Gen5_2", "GP_Gen5_4",
      "GP_Gen5_8", "GP_Gen5_16", "GP_Gen5_32", "GP_Gen5_80", "BC_Gen5_2",
      "BC_Gen5_4", "BC_Gen5_8", "BC_Gen5_16", "BC_Gen5_32", "BC_Gen5_80"
    ], var.database_sku)
    error_message = "El SKU de la base de datos debe ser uno de los valores válidos."
  }
}

variable "database_max_size_gb" {
  description = "Tamaño máximo de la base de datos en GB"
  type        = number
  default     = 2
  
  validation {
    condition     = var.database_max_size_gb >= 1 && var.database_max_size_gb <= 4096
    error_message = "El tamaño de la base de datos debe estar entre 1 y 4096 GB."
  }
}

variable "storage_account_tier" {
  description = "Tier de la cuenta de almacenamiento"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "El tier de almacenamiento debe ser Standard o Premium."
  }
}

variable "storage_replication_type" {
  description = "Tipo de replicación de la cuenta de almacenamiento"
  type        = string
  default     = "LRS"
  
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_replication_type)
    error_message = "El tipo de replicación debe ser uno de: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "powerbi_sku" {
  description = "SKU de Power BI Embedded"
  type        = string
  default     = "A1"
  
  validation {
    condition     = contains(["A1", "A2", "A3", "A4", "A5", "A6"], var.powerbi_sku)
    error_message = "El SKU de Power BI debe ser uno de: A1, A2, A3, A4, A5, A6."
  }
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "Development"
  
  validation {
    condition     = contains(["Development", "Testing", "Staging", "Production"], var.environment)
    error_message = "El entorno debe ser uno de: Development, Testing, Staging, Production."
  }
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "Movies Analytics"
}

variable "tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "Movies Analytics"
    Owner       = "Data Team"
    CostCenter  = "Analytics"
  }
}