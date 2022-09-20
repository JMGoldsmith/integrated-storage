#!/bin/bash

terraform apply -auto-approve

vault operator init -key-shares=1 -key-threshold=1 > vault/vault.tmp

# while : ; do
#     [[ -f "vault/vault.tmp" ]] && break
#     echo "Pausing until file exists."
#     sleep 1
# done

# ## Get key and unseal
# KEY=$(grep "Unseal Key" vault/vault.tmp)
# IFS=":" read name key_value <<< $KEY
# key_value="${key_value:1}"
# echo $key_value

# vault operator unseal $key_value

# ## Get token and log in
# TOKEN=$(grep "Initial Root Token" vault/vault.tmp)
# IFS=":" read name token_value <<< $TOKEN
# token_value="${token_value:1}"
# echo $token_value

# vault login $token_value

## join other nodes.

### Make array based on number of nodes(get from query or input?)
### Take out existing leader node ID
### Join others based on remaining items in array.


## Enable audit devices

# vault audit enable file file_path=/vault/logs/vault_audit.log

## Enable a few engines

