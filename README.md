stuttgart-things/install-configure-vault
=========================================

This Ansible role can completely set up and configure a hashicorp vault. The entire ansible logic is based on api calls. No client binary is required.
In addition to the installation, this role can also be used to fill the vault with data and issue certificates and much more.

### Features:
- Install vault (within a podman container)
- Initialize new vault installation
- Create a vault root certification authority
- Provide and issue trusted certificates for services such as letsencrypt
- Create local users
- Create key value databases
- Add key value data (WIP)
- Upload local files to vault secret store
- Generate .bashrc file for fully automated environment handling (WIP)
- Automated certificate installation (WIP)


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
</details>

## Requirements and Dependencies:
- Ubuntu 20.04
- Ubuntu 18.04
- CentOS 8
- CentOS 7

## Version:
```
DATE         WHO       		  WHAT
20201013     Marcel Zapf        Init readme, role wip
```

License
-------

BSD

Author Information
------------------

Marcel Zapf; 10/2020; SVA GmbH