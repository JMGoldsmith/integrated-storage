api_addr      = "http://10.0.42.200:8200"
cluster_name  = "repl"
log_level     = "trace"
ui            = true
disable_mlock = true
license_path = "/vault/config/vault.hclic"

storage "file" {
  path = "/vault/file"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

sentinel {
  additional_enabled_modules = ["http"]
}