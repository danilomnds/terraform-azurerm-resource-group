# Module - Resource Group
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()
[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

Module developed to standardize the creation of resource groups.

## Compatibility Matrix

| Module Version | Terraform Version | AzureRM Version |
|----------------|-------------------| --------------- |
| v1.0.0         | v1.5.7            | 3.74.0          |

## Specifying a version

To avoid that your code get updates automatically, is mandatory to set the version using the `source` option. 
By defining the `?ref=***` in the the URL, you can define the version of the module.

Note: The `?ref=***` refers a tag on the git module repo.

## Use case
```hcl
module "<resource group name>" {
  source                         = "git::https://github.com/danilomnds/terraform-azurerm-resource-group?ref=v1.0.0"
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

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | name that will be given to the resource group | `string` | n/a | `Yes` |
| location | azure region | `string` | n/a | `Yes` |
| tags | tags for the resource | `map(string)` | `{}` | No

  ## Output variables

| Name | Description |
|------|-------------|
| name | resource group name|
| location | resource group location |
| id | resource group id |

## Documentation
Terraform Resource Group: <br>
[https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)