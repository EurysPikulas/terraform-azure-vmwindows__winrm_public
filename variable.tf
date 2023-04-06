#-----RG & NETWORK--------------------------------------

variable "rg" {
  description = "Ressource group name"
  default = "rg-tests-xops-devt-ne"
}

variable "rg_vnet" {
  description = "Ressource group vnet name"
  default = "rg-infra-network-northeurope"
}

variable "vnet" {
  description = "Virtual Network name"
  default = "vnet-dsseswayodev01"
}

variable "subnet" {
  description = "Subnet name"
  default = "Subnet_App_01"
}



#-----VM ACCES--------------------------------------

variable "admin" {
  description = "Virtual Machine : USERNAME"
  default = "adminuser"
}

variable "admin_password" {
  description = "Virtual Machine : PASSWORD"
  default = "adminuser@2023"
}



#-----VM DISK--------------------------------------

variable "size" {
  description = "Virtual Machine : SIZE"
  default = "Standard_D2s_v3"
}

variable "diskType" {
  description = "Virtual Machine : DISK TYPE"
  default = "StandardSSD_LRS"
}


variable "image" {
  description = "Virtual Machine : IMAGE"
  default = "2019-datacenter-gensecond"
}



#-----TAG--------------------------------------------------

variable "tags" {
  type = map(any)
    default = {
        "CloudGuard-Internet" = "REGULAR"
        "CloudGuard-KMSAzur" = "TRUE"
        "CloudGuard-WindowsUpdate"= "TRUE"
        "Secured_by" = "CrowdStrike&Qualys"
    }
  description = "Tags"
}



#-----NAMING CONVENTION--------------------------------------

variable "product" {
  description ="Naming convention : Product / Product line"
  default = "tests"
}

variable "customer" {
  description ="Naming convention : Customer / Customer site / Project / Team"
  default = "xops"
}

variable "environment" {
  description ="Naming convention : Environment"
  default = "dev"
}



#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------


#Locals variables for all naming convention 
locals {
  common_name = "${var.product}-${var.customer}-${var.environment}-${var.cloud_region}-${var.ressource_number}"
  computer_name = "${var.customer}-${var.environment}"
  tags = var.tags
}
variable "numb_rs" {
 description = "Number VM : COUNT"
 default = "1"
}
variable "rg_blob" {
  description = "Ressource group Blob name"
  default = "rg-tests-eurys-dev-ne-01"
}
variable "location" {
  description = "The Azure Region in which all resources should be provisioned"
  default = "North Europe"
}
variable "imageVersion" {
  description = "Virtual Machine : IMAGE VERSION"
  default = "latest"
}
variable "cloud_region" {
  default = "ne"
}
variable "ressource_number" {
  default = "01"
}
variable "direction" {
  default = "Inbound"
}
variable "protocol" {
  default = "Tcp"
}
#-------------------------------------------------------------------------------

