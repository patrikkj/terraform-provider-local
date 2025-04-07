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

# Create a local file
resource "local_file" "test" {
  filename = "test.txt"
  content  = "Hello, World!"
}

# Execute a local command
resource "local_exec" "test" {
  command = "echo 'Command executed' > command_output.txt"
}
