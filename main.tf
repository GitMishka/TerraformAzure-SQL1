terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "random" {
  length  = 8
  lower   = true
  number  = true  
  special = false
  upper   = false
}

resource "azurerm_resource_group" "postgres" {
  name     = "rg-${random_string.random.result}"
  location = "East US"
}

resource "azurerm_postgresql_server" "postgres" {
  name                = "pg-${random_string.random.result}"
  location            = azurerm_resource_group.postgres.location
  resource_group_name = azurerm_resource_group.postgres.name
  sku_name            = "B_Gen5_1"
  storage_mb          = 5120
  version             = "11"

  administrator_login          = "" // insert user
  administrator_login_password = "" // insert password

  ssl_enforcement_enabled = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

resource "azurerm_postgresql_database" "postgresdb" {
  name                = "db-${random_string.random.result}"
  resource_group_name = azurerm_resource_group.postgres.name
  server_name         = azurerm_postgresql_server.postgres.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
