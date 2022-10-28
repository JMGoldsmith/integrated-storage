# Vault cluster with integrated storage for replication purposes.

This cluster is intended to be used as a building block for other replication environments.

To run this as vault enterprise, add your vault.hclic file to the config directory.

Currently the version selection will go to the `vault_version` variable on line 20 in main.tf. This will change in the future to be called from a module.

# Using on an M1 Mac

```
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.16.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
  }
  required_version = ">= 0.13"
}
```

```
brew install kreuzwerker/taps/m1-terraform-provider-helper
m1-terraform-provider-helper activate
m1-terraform-provider-helper install hashicorp/template -v v2.2.0
```