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
  description = "Blue-Green lab resource group"
  type        = string
  default     = "rg-bluegreen-lab"
}

variable "vm_size" {
  description = "VM size for Blue and Green"
  type        = string
  default     = "Standard_B2ats_v2"
}

variable "active_color" {
  description = "Color currently receiving traffic"
  type        = string
  default     = "blue"

  validation {
    condition     = contains(["blue", "green"], var.active_color)
    error_message = "active_color must be blue or green."
  }
}
