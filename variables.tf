variable "aws_region" {
  description = "Región donde se desplegará la infraestructura"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Nombre del proyecto para etiquetas"
  type        = string
  default     = "seabook"
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "public_subnets" {
  description = "Lista de subnets públicas para el balanceador"
  type        = list(string)
}

variable "private_subnets" {
  description = "Lista de subnets privadas para los servidores"
  type        = list(string)
}