variable "resource_group_name" {
  type        = string
  default     = "Benedetta"
}

variable "location" {
  type        = string
  default     = "Central US"
}

variable "storage_account_name" {
  type        = string
  default     = "benedettaml7710181910"
}

variable "container_name" {
  type        = string
  default     = "bls"
}

variable "function_app_name" {
  type        = string
  default     = "bls-population-fetcher"
}

variable "app_service_plan_name" {
  type        = string
  default     = "bls-function-plan"
}

variable "population_url" {
  type        = string
  default     = "https://datausa.io/api/data?drilldowns=Nation&measures=Population"
}
