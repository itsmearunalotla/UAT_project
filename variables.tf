# Input Variables
# Azure Region
variable "location" {
  description = "Location in which Azure Resources will be created"
  type        = string
}

variable "environment" {
  description = "Environment name for common resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network (VNet)"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for the Virtual Network (VNet)"
  type        = string
}

variable "public_subnets_cidr" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = []
}

variable "private_lb_subnets_cidr" {
  description = "CIDR blocks for the private load balancer subnets"
  type        = list(string)
  default     = []
}

variable "private_app_subnets_cidr" {
  description = "CIDR blocks for the private application subnets"
  type        = list(string)
  default     = []
}

variable "private_db_subnets_cidr" {
  description = "CIDR blocks for the private database subnets"
  type        = list(string)
  default     = []
}

variable "private_vpce_subnets_cidr" {
  description = "CIDR blocks for the private VPC endpoint subnets"
  type        = list(string)
  default     = []
}

variable "private_tgw_subnets_cidr" {
  description = "CIDR blocks for the private transit gateway subnets"
  type        = list(string)
  default     = []
}


