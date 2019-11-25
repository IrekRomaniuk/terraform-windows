variable "prefix" {
  description = "The Prefix used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which the resources in this example should exist"
}

variable "admin_password" {}
variable "admin_username" {}

variable "vault" {}
variable "rg_vault" {}
variable "rg_vm" {}
variable "cert_uri" {}
variable "vnet" {}
variable "subnet" {}
