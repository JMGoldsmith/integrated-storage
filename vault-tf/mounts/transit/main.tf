provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR
  # But can be set explicitly
  # address = "https://vault.example.net:8200"
}

resource "vault_mount" "transit" {
  path                      = "transit"
  type                      = "transit"
  description               = "Example description"
  seal_wrap                 = true
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

# resource "vault_transit_secret_backend_key" "key" {
#   backend                = vault_mount.transit.path
#   name                   = "my_key"
#   exportable             = true
#   allow_plaintext_backup = true
#   deletion_allowed       = true
# }
