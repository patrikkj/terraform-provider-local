# Terraform Local Provider

A Terraform provider for managing local files and executing local commands.

## Provider Configuration

```hcl
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
```

## Data Sources

#### `local_exec` - Execute Commands (read-only)

```hcl
data "local_exec" "example" {
  command         = "uname -a"  # Required: Command to execute
  fail_if_nonzero = true        # Optional: Fail on non-zero exit (defaults to true)
}

# Available outputs:
output "example" {
  value = {
    output     = data.local_exec.example.output    # The command's output
    exit_code  = data.local_exec.example.exit_code # The command's exit code
  }
}
```

#### `local_file` - Read Files

```hcl
data "local_file" "example" {
  path = "existing_config.yml"  # Required: Local file path
}

# Available outputs:
output "example" {
  value = {
    content = data.local_file.example.content  # The file's contents
    id      = data.local_file.example.id      # Unique identifier for this file
  }
}
```

## Resources

#### `local_exec` - Execute Commands

```hcl
resource "local_exec" "example" {
  command = <<-EOT
    echo "Deploying service..."
    echo "Environment: ${var.environment}"
  EOT

  on_destroy      = "echo 'Cleaning up...'"  # Optional: Command to run on destruction
  fail_if_nonzero = true                     # Optional: Fail on non-zero exit (defaults to true)
}

# Available outputs:
output "example" {
  value = {
    output     = local_exec.example.output    # The command's output
    exit_code  = local_exec.example.exit_code # The command's exit code
    id         = local_exec.example.id        # Unique identifier (same as command)
  }
}
```

#### `local_file` - Write Files

```hcl
resource "local_file" "example" {
  path = "config.json"  # Required: Local file path

  # Required: File content
  content = jsonencode({
    database_url = "postgresql://db.internal:5432/myapp"
    api_key      = var.api_key
    environment  = var.environment
  })
}

# Available outputs:
output "example" {
  value = {
    content = local_file.example.content  # The file's contents
    id      = local_file.example.id      # Unique identifier for this file
  }
}
```

## Features

The local provider offers two main types of resources:

1. **File Management**

   - Create and manage local files
   - Read existing local files
   - Support for nested directories
   - Automatic directory creation

2. **Command Execution**
   - Execute local commands
   - Capture command output
   - Handle command exit codes
   - Support for cleanup commands on resource destruction

## Examples

### Basic File Creation

```hcl
resource "local_file" "config" {
  path    = "config.json"
  content = jsonencode({
    setting = "value"
  })
}
```

### Command Execution

```hcl
resource "local_exec" "setup" {
  command = <<-EOT
    echo "Setting up environment..."
    mkdir -p ./data
  EOT
}
```

### Reading Existing Files

```hcl
data "local_file" "config" {
  path = "existing_config.json"
}

output "config_content" {
  value = data.local_file.config.content
}
```

### Command Output Capture

```hcl
data "local_exec" "system_info" {
  command = "uname -a"
}

output "system_info" {
  value = data.local_exec.system_info.output
}
```
