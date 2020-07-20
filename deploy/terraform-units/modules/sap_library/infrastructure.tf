/*
Description:
  Define infrastructure resources for deployer(s).
*/

resource azurerm_resource_group library {
  # Naming Standard:  {DEPLOYZONE}-{REGION_MAP}-LIBRARY
  name = "${upper(var.deployZone)}-${
  upper(lookup(var.regionMap, var.region, "unknown"))}-SAP_LIBRARY"

  location = var.region
  tags     = var.tags
}

resource random_id library {
  byte_length = 8
}

resource azurerm_storage_account library {
  # Naming Standard:  {deployzone}{region_map}library
  name = "${lower(lookup(var.deployZoneMap, var.deployZone, "unknown"))}${
    lower(lookup(var.regionMap, var.region, "unknown"))}lib${
  lower(random_id.library.hex)}"


  resource_group_name      = azurerm_resource_group.library.name
  location                 = azurerm_resource_group.library.location
  tags                     = var.tags
  account_kind             = "Storage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  network_rules {
    default_action = "Allow"
  }
}


/*-----------------------------------------------------------------------------8
|                                                                              |
|                                  CONTAINER                                   |
|                                                                              |
+--------------------------------------4--------------------------------------*/
resource azurerm_storage_container sapbits {
  name                  = "sapbits"
  storage_account_name  = azurerm_storage_account.library.name
  container_access_type = "private"
}

// Creates storage account with container for remote state files, soft deletion enabled
// TODO: support blob versioniong (https://docs.microsoft.com/en-us/azure/storage/blobs/versioning-enable?tabs=portal)
resource "azurerm_storage_account" "tfstate" {
  name                      = "sapdeployer${local.postfix}"
  resource_group_name       = azurerm_resource_group.deployer.name
  location                  = azurerm_resource_group.deployer.location
  account_replication_type  = "LRS"
  account_tier              = "Standard"
  enable_https_traffic_only = local.enable_secure_transfer
  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# TODO: private endpoint (To be created by sap VNET code)

