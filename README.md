# Single vault node for replication purposes.

This single node is intended to be used as a building block for other replication environments.

To run this as vault enterprise, add your vault.hclic file to the config directory.

Currently the version selection will go to the `vault_version` variable on line 20 in main.tf. This will change in the future to be called from a module.