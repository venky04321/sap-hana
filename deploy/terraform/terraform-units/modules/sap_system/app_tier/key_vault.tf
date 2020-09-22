/*
  Description:
  Set up key vault for application
*/

data "azurerm_client_config" "deployer" {}

// Create private KV with access policy
resource "azurerm_key_vault" "kv_prvt" {
  count                      = local.enable_deployment ? 1 : 0
  name                       = local.kv_private_name
  location                   = local.region
  resource_group_name        = var.resource-group[0].name
  tenant_id                  = data.azurerm_client_config.deployer.tenant_id
  soft_delete_enabled        = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  sku_name                   = "standard"
}

resource "azurerm_key_vault_access_policy" "kv_prvt_msi" {
  count        = local.enable_deployment ? 1 : 0
  key_vault_id = azurerm_key_vault.kv_prvt[0].id

  tenant_id = data.azurerm_client_config.deployer.tenant_id
  object_id = var.deployer-uai.principal_id

  secret_permissions = [
    "get",
  ]
}

// Create user KV with access policy
resource "azurerm_key_vault" "kv_user" {
  count                      = local.enable_deployment ? 1 : 0
  name                       = local.kv_user_name
  location                   = local.region
  resource_group_name        = var.resource-group[0].name
  tenant_id                  = data.azurerm_client_config.deployer.tenant_id
  soft_delete_enabled        = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "kv_user_msi" {
<<<<<<< HEAD
  count        = local.enable_deployment ? 1 : 0
  key_vault_id = azurerm_key_vault.kv_user[0].id
=======
  key_vault_id = azurerm_key_vault.kv_user.id
>>>>>>> 594db2a... tf format
  tenant_id    = data.azurerm_client_config.deployer.tenant_id
  object_id    = var.deployer-uai.principal_id

  secret_permissions = [
    "delete",
    "get",
    "list",
    "set",
  ]
}

resource "azurerm_key_vault_access_policy" "kv_user_portal" {
<<<<<<< HEAD
  count        = local.enable_deployment ? length(local.kv_users) : 0
  key_vault_id = azurerm_key_vault.kv_user[0].id
=======
  count        = length(local.kv_users)
  key_vault_id = azurerm_key_vault.kv_user.id
>>>>>>> 594db2a... tf format
  tenant_id    = data.azurerm_client_config.deployer.tenant_id
  object_id    = local.kv_users[count.index]

  secret_permissions = [
    "delete",
    "get",
    "list",
    "set",
  ]
}

// Generate random password if password is set as authentication type and user doesn't specify a password
resource "random_password" "password" {
  count = (
    local.enable_auth_password
  && try(local.authentication.password, null) == null) ? 1 : 0
  length           = 16
  special          = true
  override_special = "_%@"
}

// random bytes to product
resource "random_id" "sapsystem" {
  byte_length = 4
}

/*
 To force dependency between kv access policy and secrets. Expected behavior:
 https://github.com/terraform-providers/terraform-provider-azurerm/issues/4971
*/
// for logon use
resource "azurerm_key_vault_secret" "auth_username" {
  depends_on   = [azurerm_key_vault_access_policy.kv_user_msi]
  count        = local.enable_auth_password ? 1 : 0
  name         = format("%s-sid-logon-username", local.prefix)
  value        = local.sid_auth_username
  key_vault_id = azurerm_key_vault.kv_user[0].id
}

// for logon use
resource "azurerm_key_vault_secret" "auth_password" {
  depends_on   = [azurerm_key_vault_access_policy.kv_user_msi]
  count        = local.enable_auth_password ? 1 : 0
  name         = format("%s-sid-logon-password", local.prefix)
  value        = local.sid_auth_password
  key_vault_id = azurerm_key_vault.kv_user[0].id
}

// retrieve public key from sap landscape's Key vault
data "azurerm_key_vault_secret" "sid_pk" {
  count        = local.enable_auth_key ? 1 : 0
  name         = local.secret_sid_pk_name
  key_vault_id = local.kv_landscape_id
}
