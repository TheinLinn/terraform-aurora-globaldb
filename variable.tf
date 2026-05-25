variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "primary_region" {
  type        = string
  description = "Primary AWS region"
}

variable "dr_region" {
  type        = string
  description = "DR AWS region"
}

variable "primary_vpc_cidr" {
  type = string
}

variable "dr_vpc_cidr" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_instance_class" {
  type = string
}

variable "engine_version" {
  type = string
}