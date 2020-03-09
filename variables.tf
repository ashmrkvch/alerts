variable "credentials_file" {
  description = "Path to the service account key file in JSON format"
  type        = string
}
variable "project" {
  description = "The ID of the project"
  type        = string
}
variable "region" {
  description = "Default project region"
  type        = string
}
variable "zone" {
  description = "Default project zone"
  type        = string
}

variable "monitoring" {
   description = "DNS, port and path of checking resource"
   type        = list(string)
}

variable "email_adress" {
    description = "Email for notifications"
    default     = "anhelina.shemrikovych@nure.ua"
}

