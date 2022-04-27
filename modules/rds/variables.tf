variable "engine" {
  description = "Database engine"
  type = string
}

variable "engine_version" {
  description = "Database engine's version"
  type = string
}

variable "instance_class" {
  description = "Database instance's class"
  type = string
}

variable "name" {
  description = "Database's name"
  type = string
}

variable "username" {
  description = "Database instance's login username"
  type = string
  sensitive = true
}

variable "password" {
  description = "Database instance's login password"
  type = string
  sensitive = true
}

variable "parameter_group_name" {
  description = "Database's default parameter group"
  type = string
}