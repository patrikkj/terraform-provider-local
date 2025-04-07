# Provider Configuration
# ---------------------
terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "local.providers/patrikkj/local"
      version = "~> 0.1.0"
    }
  }
}
provider "local" {}

# File Resource Examples
# --------------------

# Basic file management
resource "local_file" "app_config" {
  path = "config.json"
  content = jsonencode({
    database_url = "postgresql://db.internal:5432/myapp"
    api_key      = var.api_key
    environment  = var.environment
  })
}

# File with sensitive content
resource "local_file" "secure_file" {
  path    = "secure.txt"
  content = "Sensitive content"
}

# File in nested directory
resource "local_file" "nested_file" {
  path    = "nested/dir/config.yml"
  content = <<-EOT
    environment: ${var.environment}
    debug: false
  EOT
}

# File Data Source Example
# ----------------------
data "local_file" "existing_config" {
  path = "existing_config.yml"
}

# Command Execution Resource Example
# -------------------------------
resource "local_exec" "service_deployment" {
  command = <<-EOT
    echo "Deploying service..."
    echo "Environment: ${var.environment}"
  EOT

  on_destroy      = "echo 'Cleaning up...'"
  fail_if_nonzero = true
}

# Command Execution Data Source Example
# ---------------------------------
data "local_exec" "system_info" {
  command         = "uname -a"
  fail_if_nonzero = true
}

# Outputs
# -------
output "config_content" {
  value     = data.local_file.existing_config.content
  sensitive = true
}

output "system_info" {
  value = data.local_exec.system_info.output
}

# Variables
# --------
variable "api_key" {
  type      = string
  sensitive = true
}

variable "environment" {
  type    = string
  default = "production"
}
