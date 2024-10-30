variable "availability_zones" {
  description = "eu-west-1 AZs"
  type        = list(string)
}

variable "db_private_subnet_name" {
  description = "Private subnet name"
  type        = string
}

variable "db_instance_name" {
  description = "Name of the database"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_user" {
  description = "Name of the admin user"
  type        = string
}

variable "db_password" {
  description = "Password of the database"
  type        = string
}

variable "db_security_group" {
  description = "Name of the database security group"
  type        = string
}

variable "service_security_group_id" {
  description = "Name of the security group to associate with the database instance"
  type        = string
}

variable "db_subnet_group_name" {
  description = "Name of the security group to associate with the database instance"
  type        = string
}



