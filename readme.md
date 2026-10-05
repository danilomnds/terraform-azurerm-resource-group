# Module - Resource Group
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

Module developed to standardize the creation of resource groups.

## Compatibility Matrix

| Module Version | Terraform Version | AzureRM Version | Notes |
|---|---|---|---|
| v1.0.0 | v1.3.8 | 3.74.0 | module creation |
| v1.1.0 | v1.3.8 | 3.74.0 | output addition |
| v1.2.0 | v1.14.3 | 4.57.0 | module review to azurerm 4 |
| v5.8.0 | >= 1.16.5 | >= 5.8.0 | Optional managed_by, timeouts, and Reader access for Entra ID groups |

---
## Specifying a version

To prevent automatic code updates, you must specify a version using the `source` option.
Define the `?ref=***` parameter in the URL to specify the module version.

Note: The `?ref=***` parameter refers to a tag in the git module repository.

---
## Use case

Configure the AzureRM provider in the consuming root module, not inside this module:

```hcl
provider "azurerm" {
  features {}
  subscription_id = "00000000-0000-0000-0000-000000000000"
}
```

Authenticate using your environment's supported Azure credentials. Do not store credentials in module inputs or source control.

### Minimal Example

```hcl
module "resource_group" {
  source   = "git::https://github.com/danilomnds/terraform-azurerm-resource-group?ref=v5.8.0"
  name     = "example-resources"
  location = "West Europe"

  tags = {
    environment = "development"
  }
}
```

### Reader Access for Entra ID Groups

```hcl
module "resource_group" {
  source   = "git::https://github.com/danilomnds/terraform-azurerm-resource-group?ref=v5.8.0"
  name     = "example-resources"
  location = "West Europe"

  azure_ad_groups = [
    "00000000-0000-0000-0000-000000000001",
    "00000000-0000-0000-0000-000000000002"
  ]

  resource_group_timeouts = {
    create = "120m"
    delete = "120m"
  }

  role_assignment_timeouts = {
    create = "45m"
  }

  tags = {
    project = "example"
  }
}

output "name" {
  value = module.resource_group.name
}

output "location" {
  value = module.resource_group.location
}

output "id" {
  value = module.resource_group.id
}
```

Group values must be Microsoft Entra ID Object IDs, not names or application IDs. Duplicate Object IDs produce only one assignment. Empty `azure_ad_groups` creates no assignments. The role is fixed to `Reader`, principal type to `Group`, and scope to the created Resource Group; arbitrary roles and other principal types are intentionally not exposed.

When groups are configured, the deploying identity needs `Microsoft.Authorization/roleAssignments/write` at the applicable scope in addition to permission to create the Resource Group. `Contributor` alone cannot create role assignments. Group membership grants access to the Resource Group and its child resources through inherited Reader permissions.

### Tags and Lifecycle

Default tags are `deployedby = "Terraform"`, `provider = "azr"`, normalized `region`, and `create_date` (UTC-3). Caller-supplied `tags` override defaults. Changes to `create_date` are ignored after creation to prevent timestamp-only perpetual diffs.

Changing `name`, `location`, or `managed_by` replaces the Resource Group. Review replacement plans carefully because deleting a Resource Group can delete its child resources.

---
## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the Resource Group | `string` | n/a | Yes |
| location | Azure region where the Resource Group should exist | `string` | n/a | Yes |
| managed_by | ID of the resource or application that manages the Resource Group; changing it forces replacement | `string` | `null` | No |
| tags | Tags assigned to the Resource Group, merged with defaults | `map(string)` | `{}` | No |
| azure_ad_groups | Entra ID group Object IDs receiving Reader access on the Resource Group | `list(string)` | `[]` | No |
| resource_group_timeouts | Optional Resource Group operation timeouts | `object({ create = optional(string), read = optional(string), update = optional(string), delete = optional(string) })` | `null` | No |
| role_assignment_timeouts | Optional Reader role assignment operation timeouts | `object({ create = optional(string), read = optional(string), update = optional(string), delete = optional(string) })` | `{ create = null, read = null, update = null, delete = null }` | No |

Omitted timeout attributes use provider defaults. Use duration strings such as `"30m"` or `"2h"`.

| Resource | create | read | update | delete |
|---|---|---|---|---|
| Resource Group | `90m` | `5m` | `90m` | `90m` |
| Reader role assignment | `30m` | `5m` | `30m` | `30m` |

---
## Output variables

| Name | Description |
|------|-------------|
| name | resource group name|
| location | resource group location |
| id | resource group id |

## Documentation
Terraform Resource Group: <br>
[https://registry.terraform.io/providers/hashicorp/azurerm/5.8.0/docs/resources/resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/5.8.0/docs/resources/resource_group)

AzureRM Role Assignment: <br>
[https://registry.terraform.io/providers/hashicorp/azurerm/5.8.0/docs/resources/role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/5.8.0/docs/resources/role_assignment)

## Release Notes

### [v5.8.0] - 2026-10-05

#### Added
- Optional `managed_by` and configurable Resource Group operation timeouts.
- Reader role assignments for Entra ID group Object IDs in `azure_ad_groups`.
- Configurable create, read, update, and delete timeouts for Reader role assignments.

#### Changed
- Raised the Terraform CLI minimum from `1.14.3` to `1.16.5` and AzureRM minimum from `4.57.0` to `5.8.0`.
- Kept provider configuration in the consuming root module.
- Preserved public module tags, the existing outputs, and the `create_date` lifecycle ignore rule.

#### Fixed
- Corrected the reversed descriptions of `name` and `location` and documented every module input.
- Replaced invalid example module labels with executable HCL examples using the public GitHub source.

#### Migration
- Existing inputs and outputs remain available; no public module parameters were removed or deprecated.
- New inputs are optional and create no RBAC assignments unless `azure_ad_groups` is populated.
- Consumers must meet the new version requirements and review the AzureRM 5.0 upgrade guide when upgrading from AzureRM 4.x.