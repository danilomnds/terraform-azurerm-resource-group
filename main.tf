resource "azurerm_resource_group" "rg" {
  name       = var.name
  location   = var.location
  managed_by = var.managed_by
  tags       = local.tags

  dynamic "timeouts" {
    for_each = var.resource_group_timeouts == null ? [] : [var.resource_group_timeouts]
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  lifecycle {
    ignore_changes = [
      tags["create_date"]
    ]
  }
}

resource "azurerm_role_assignment" "role_assignments" {
  for_each = toset(var.azure_ad_groups)

  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = each.value
  principal_type       = "Group"
  description          = "Reader access for Entra ID group on this resource group."
}