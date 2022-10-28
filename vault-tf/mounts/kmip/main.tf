provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR
  # But can be set explicitly
  # address = "https://vault.example.net:8200"
}

resource "vault_kmip_secret_backend" "default" {
  path                        = "kmip"
  description                 = "Vault KMIP backend"
  listen_addrs                = ["127.0.0.1:5696", "127.0.0.1:8080"]
  tls_ca_key_type             = "rsa"
  tls_ca_key_bits             = 4096
  default_tls_client_key_type = "rsa"
  default_tls_client_key_bits = 4096
  default_tls_client_ttl      = 86400
}

data "vault_generic_secret" "example_creds" {
  path = "kmip/config"
}
