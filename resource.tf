resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location
  tags = local.tags
  lifecycle {
    ignore_changes = [
      tags["create_date"]
    ]
  }
}