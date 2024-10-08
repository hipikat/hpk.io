# Authentication
variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

# DNS record management
variable "tld" {
  description = "Top-level domain"
  type        = string
  default     = "hpk.io"
}

variable "subdomain" {
  description = "The subdomain name for the DNS record"
  type        = string
  default     = null
}

# Server infrastructure
variable "ssh_fingerprint" {
  description = "SSH key fingerprint"
  type        = string
}

variable "server_name" {
  description = "Name of the Droplet"
  type        = string
  default     = null
}

variable "region" {
  description = "Region for the Droplet"
  type        = string
  default     = "syd1"
}

variable "size" {
  description = "Size of the Droplet"
  type        = string
  default     = "s-1vcpu-1gb-amd"
}

variable "image" {
  description = "Droplet image"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "monitoring" {
  description = "Enable monitoring"
  type        = bool
  default     = false
}

variable "backups" {
  description = "Enable backups"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for the Droplet"
  type        = list(string)
  default     = []
}


variable "cloud_init_config" {
  description = "Path to cloud-init configuration file"
  type        = string
}