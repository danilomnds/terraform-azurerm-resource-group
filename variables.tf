variable "name" {
  type        = string
  description = "The Name which should be used for this Resource Group."
}

variable "location" {
  type        = string
  description = "The Azure Region where the Resource Group should exist."
}

variable "managed_by" {
  type        = string
  description = "Optional ID of the resource or application that manages this Resource Group. Changing this value replaces the Resource Group."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags which should be assigned to the Resource Group."
  default     = {}
}

variable "azure_ad_groups" {
  type        = list(string)
  description = "List of Microsoft Entra ID group Object IDs that receive the built-in Reader role on this Resource Group. Supply Object IDs, not group names or application IDs."
  default     = []
}

variable "resource_group_timeouts" {
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  description = "Optional create, read, update, and delete timeouts for the Resource Group. Provider defaults apply to omitted values."
  default     = null
}

variable "role_assignment_timeouts" {
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  description = "Optional create, read, update, and delete timeouts for Reader role assignments. Provider defaults apply to omitted values."
  default = {
    create = null
    read   = null
    update = null
    delete = null
  }
}