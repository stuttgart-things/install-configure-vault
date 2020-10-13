stuttgart-things/install-configure-vault
=========================================

# WIP

This Ansible role can completely set up and configure a hashicorp vault. 
In addition to the installation, this role can also be used to fill the vault with data and issue certificates and many more.

Features:
-Install vault
-Initialize new vault installation
-Create a vault root certification authority
-Provide and sign trusted certificates for services such as letsencrypt
-Create local users
-Create key value databases
-Add key value data (WIP)
-Generate .bashrc file for fully automated environment handling (WIP)
-Automated certificate installation (WIP)


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
example.com
```