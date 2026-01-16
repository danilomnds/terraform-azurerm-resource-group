# Module - Resource Group
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

Module developed to standardize the creation of resource groups.

## Compatibility Matrix

| Module Version | Terraform Version | AzureRM Version | Notes |
|---|---|---|---|
| v1.0.0 | v1.3.8 | 3.74.0 | module creation |
| v1.1.0 | v1.3.8 | 3.74.0 | output addition |
| v1.2.0 | v1.14.3 | 4.57.0 | module review to azurerm 4 |

---
## Specifying a version

To prevent automatic code updates, you must specify a version using the `source` option.
Define the `?ref=***` parameter in the URL to specify the module version.

Note: The `?ref=***` parameter refers to a tag in the git module repository.

---
## Use case
```hcl
module "<resource group name>" {
  source                         = "git::https://github.com/danilomnds/terraform-azurerm-resource-group?ref=v1.2.0"
  name                           = "<resource group name>"
  location                       = "<region>"  
  tags = {
    "key1" = "value1"
    "key2" = "value2"    
  }
}
output "name" {
  value = module.<resource group name>.name
}
output "location" {
  value = module.<resource group name>.location
}
output "id" {
  value = module.<resource group name>.id
}
```
---
## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The Azure Region where the Resource Group should exist | `string` | n/a | `Yes` |
| location | The Name which should be used for this Resource Group | `string` | n/a | `Yes` |
| tags | A mapping of tags which should be assigned to the Resource Group | `map(string)` | `{}` | No

---
## Output variables

| Name | Description |
|------|-------------|
| name | resource group name|
| location | resource group location |
| id | resource group id |

## Documentation
Terraform Resource Group: <br>
[https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)