variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "vm_name" {
  type = string
}
variable "vm_zone" {
  type = string
}
variable "nic_name" {
  type = string
}
variable "subnet_id" {
  type = any
}
variable "vm_size" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "admin_password" {
  type = string
}
variable "network_security_group_id" {
  type = string
}
variable "nat_rule_id" {
  type = string
}
variable "public_ip_address_id" {
  type = any
}
variable "backend_address_pool_id" {
  type = any
}
variable "host_ip" {
  type = any
}
variable nat_port{
  type = any
}
