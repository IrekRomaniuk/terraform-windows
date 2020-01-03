variable "prefix" {
  description = "The Prefix used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which the resources in this example should exist"
}

# variable "admin_password" {}

variable "vault" {}
variable "rg_vault" {}
variable "rg_vm" {}

variable "rg_vnet" {}
variable "cert_uri" {}
variable "vnet" {}
variable "subnet" {}

variable "secret" {}
variable "vm_size" {}

variable "ip_address" {}

variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "administrator user name"
  default     = "manager"
}

/*variable "admin_password" {
  description = "administrator password (recommended to disable password auth)"
  default     = "notused"
}*/
