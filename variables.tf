variable "compute_flavor" {
  type    = string
  default = "Standard-2-4-40"
}

variable "key_pair_name" {
  type    = string
  default = "keypair-terraform"
}

variable "availability_zone_name" {
  type    = string
  default = "MS1"
}

variable "lastname" {
  type    = string
  default = "PanyutinMA"
}

variable "disk_size" {
  type    = number
  default = 20
}

# Добавляем переменные, которые ожидает vkcs_provider.tf
variable "vkcs_username" {
  type    = string
  description = "VK Cloud username"
}

variable "vkcs_password" {
  type    = string
  description = "VK Cloud password"
  sensitive = true
}

variable "vkcs_project_id" {
  type    = string
  description = "VK Cloud project ID"
}

variable "vkcs_region" {
  type    = string
  description = "VK Cloud region"
  default = "RegionOne"  # Для VK Cloud обычно RegionOne
}

variable "ssh_public_key" {
  type    = string
  description = "SSH public key for VM access"
}
