stuttgart-things/install-configure-vault
=========================================

# WIP

This role can read and write files as well as passwords and KV data from the Hashicorp Vault. It is also possible to write key / value data as environment variables in the system.

Requirements
------------

installs role and all of it's dependencies w/:

```
cat <<EOF > /tmp/requirements.yaml
- src: git@codehub.sva.de:Lab/stuttgart-things/supporting-roles/install-configure-vault.git
  scm: git
EOF
ansible-galaxy install -r /tmp/requirements.yaml --force
rm -rf /tmp/requirements.yaml
```