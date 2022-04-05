terraform {
  required_version = ">= 0.13"
}

# -----------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------

# tcp with hostname example:
# export TF_VAR_docker_host="tcp://docker:2345"

variable "docker_host" {
  default = "unix:///var/run/docker.sock"
}

variable "vault_license" {
  default = ""
}

variable "vault_version" {
  default = "1.9.1-ent"
}

# -----------------------------------------------------------------------
# Global configuration
# -----------------------------------------------------------------------

terraform {
  backend "local" {
    path = "tfstate/terraform.tfstate"
  }
}

# -----------------------------------------------------------------------
# Provider configuration
# -----------------------------------------------------------------------

provider "docker" {
  host = var.docker_host
}

# -----------------------------------------------------------------------
# Custom network
# -----------------------------------------------------------------------
resource "docker_network" "repl_network" {
  name       = "repl-network"
  attachable = true
  ipam_config { subnet = "10.42.10.0/24" }
}


# -----------------------------------------------------------------------
# Vault data and resources
# -----------------------------------------------------------------------

data "template_file" "vault_configuration" {
  template = file("${path.cwd}/config/vault.hcl")
}

data "template_file" "vault_license" {
  template = file("${path.cwd}/config/vault.hclic")
}

resource "docker_image" "vault" {
  name         = "hashicorp/vault-enterprise:${var.vault_version}"
  keep_locally = true
}

resource "docker_container" "vault" {
  name  = "vault"
  image = docker_image.vault.latest
  env   = ["SKIP_CHOWN", "VAULT_ADDR=http://127.0.0.1:8200", "VAULT_LICENSE=${var.vault_license}"]
  # custom binary
  command = ["vault", "server", "-log-level=trace", "-config=/vault/config"]
  # command  = ["vault", "server", "-log-level=trace", "-config=/vault/config"]
  hostname = "vault"
  must_run = true
  capabilities {
    add = ["IPC_LOCK"]
  }
  healthcheck {
    test         = ["CMD", "vault", "status"]
    interval     = "10s"
    timeout      = "2s"
    start_period = "10s"
    retries      = 2
  }
  ports {
    internal = "8200"
    external = "8200"
    protocol = "tcp"
  }
  networks_advanced {
    name         = "repl-network"
    ipv4_address = "10.42.10.200"
  }
  upload {
    content = data.template_file.vault_configuration.rendered
    file    = "/vault/config/server.hcl"
  }
  upload {
    content = data.template_file.vault_license.rendered
    file    = "/vault/config/vault.hclic"
  }
  # custom vault binary
  volumes {
    host_path      = "${path.cwd}/vault"
    container_path = "/vault/vault"
  }
  volumes {
    host_path      = "${path.cwd}/vault-audit-log"
    container_path = "/vault/logs"
  }
}
