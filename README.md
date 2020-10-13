stuttgart-things/install-configure-vault
=========================================

# WIP

This role can read and write files as well as passwords and KV data from the Hashicorp Vault. It is also possible to write key / value data as environment variables in the system.

<details><summary>Install this role on your ansible host (klick here)</summary>

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
</details>

## Example playbooks to use this role

<details><summary>Install a vault server within a podman container (klick here)</summary>

### Ansible command:
```
ansible-playbook -i inventory.ini playbook.yml
```

### Playbook: playbook.yml
```
- hosts: "vault"
  gather_facts: true
  become: true
  vars:
    # default configuration
    vault_url: https://example.com:8200

    # Install vault server
    install_vault: true
    install_vault_init_secret_shares: 1
    install_vault_init_secret_threshold: 1

  roles:
    - install-configure-vault
```

### Playbook: inventory.ini
```
[vault]
example.c
```