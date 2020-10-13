stuttgart-things/install-configure-vault
=========================================

# WIP

This role can read and write files as well as passwords and KV data from the Hashicorp Vault. It is also possible to write key / value data as environment variables in the system.

Requirements
------------

installs role and all of it's dependencies w/:

```
cat <<EOF > ./requirements.yaml
roles:
- src: git@codehub.sva.de:Lab/stuttgart-things/supporting-roles/install-configure-vault.git
  scm: git
- src: git@codehub.sva.de:Lab/stuttgart-things/supporting-roles/install-requirements.git
  scm: git
- src: git@codehub.sva.de:Lab/stuttgart-things/supporting-roles/deploy-podman-container.git
  scm: git
- src: git@codehub.sva.de:Lab/stuttgart-things/supporting-roles/generate-selfsigned-certs.git
  scm: git
  version: stable

collections:
- name: containers.podman 
- name: community.general
- name: community.crypto
EOF
ansible-galaxy install -r ./requirements.yaml --force && ansible-galaxy collection install -r ./requirements.yaml -f
```