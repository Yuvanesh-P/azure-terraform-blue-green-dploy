variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "southindia"
}

variable "resource_group_name" {
  description = "Resource group for Terraform state storage"
  type        = string
  default     = "rg-tfstate-bluegreen"
}

variable "storage_account_name" {
  description = "Globally unique lowercase Azure storage account name"
  type        = string

  validation {
    condition = (
      length(var.storage_account_name) >= 3 &&
      length(var.storage_account_name) <= 24 &&
      can(regex("^[a-z0-9]+$", var.storage_account_name))
    )
    error_message = "Storage account name must be 3-24 lowercase letters or numbers."
  }
}
