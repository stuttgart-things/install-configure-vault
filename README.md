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
- Automated certificate installation

### Role installation:
<details><summary><b>Install this role on your ansible host (click here)</b></summary>

```
cat <<EOF > /tmp/requirements.yaml
roles:
- src: git@codehub.sva.de:Lab/stuttgart-things/supporting-roles/install-configure-vault.git
  scm: git
  version: stable
- src: git@codehub.sva.de:Lab/stuttgart-things/supporting-roles/install-requirements.git
  scm: git
  version: stable
- src: git@codehub.sva.de:Lab/stuttgart-things/supporting-roles/deploy-podman-container.git
  scm: git
- src: git@codehub.sva.de:Lab/stuttgart-things/supporting-roles/generate-selfsigned-certs.git
  scm: git
  version: stable
- src: git@codehub.sva.de:Lab/stuttgart-things/supporting-roles/install-configure-podman.git
  scm: git
  version: stable

collections:
- name: containers.podman 
- name: community.general
- name: community.crypto
EOF
ansible-galaxy install -r /tmp/requirements.yaml --force && ansible-galaxy collection install -r /tmp/requirements.yaml -f
```
</details>

For more information about stuttgart-things role installation visit: [Stuttgart-Things howto install role](https://codehub.sva.de/Lab/stuttgart-things/meta/documentation/doc-as-code/-/blob/master/howtos/howto-install-role.md)

## Example playbooks to use this role

<details><summary>Install and initializing a vault server within a podman container (click here)</summary>

### Ansible command:
```
ansible-playbook -i inventory.ini playbook.yml
```

### Playbook: playbook.yml
```
---
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

<details><summary>Create new local users (click here)</summary>

### Ansible command:
```
ansible-playbook -i inventory.ini playbook.yml
```

### Playbook: playbook.yml
```
---
- hosts: "localhost"
  gather_facts: true
  become: true
  vars:
    # default configuration
    vault_url: https://example.com:8200
    #vault_username: username
    #vault_password: password
    vault_token: <root_token> # or uncomment vault user+pw and use a admin user account

    # Create new local userpass user
    vault_create_user: true
    vault_crate_user_data:
      - name: bob
        password: secret
        policies: admins
      - name: alice
        password: supersecret
        policies: admins

  roles:
    - install-configure-vault
```

</details>

<details><summary>Create certification authority (click here)</summary>

### Ansible command:
```
ansible-playbook playbook.yml
```

### Playbook: playbook.yml
```
---
- hosts: "localhost"
  gather_facts: true
  become: true
  vars:
    # default configuration
    vault_url: https://example.com:8200
    #vault_username: username
    #vault_password: password
    vault_token: <root_token> # or uncomment vault user+pw and use a admin user account

    # CA root certificate default configuration
    vault_create_ca: true
    vault_ca_cert_common_name: mydomain.com # Best pratice the name of the domain managed by vault CA
    vault_ca_cert_key_bits: 4096
    vault_ca_cert_organization: company
    vault_ca_cert_ou: my-ou

    # CA root role
    vault_ca_cert_role_name: mydomain.com
    vault_ca_role_allow_subdomains: true
    vault_ca_role_allowed_domains: mydomain.com

  roles:
    - install-configure-vault
```

</details>

<details><summary>Install the vault certification authority ca certificate on remote system (click here)</summary>

### Ansible command:
```
ansible-playbook -i inventory.ini playbook.yml
```

### Playbook: playbook.yml
```
---
- hosts: "all"
  gather_facts: true
  become: true
  vars:
    # default configuration
    vault_url: https://example.com:8200

    # Install ca on system
    vault_install_ca_cert: true

  roles:
    - install-configure-vault
```

### Playbook: inventory.ini
```
[vault]
example.com
```
</details>

<details><summary>Request a certificate from the vault server to sign on remote system with installation (click here) </summary>

### Ansible command:
```
ansible-playbook playbook.yml
```

### Playbook: playbook.yml
```
---
- hosts: "all"
  gather_facts: true
  become: false
  vars:
    # default configuration
    vault_url: https://example.com:8200
    #vault_username: username
    #vault_password: password
    vault_token: <root_token> # or uncomment vault user+pw and use a admin user account

    # CA root role
    vault_ca_cert_role_name: example.com

    # Generate cert
    vault_gen_cert: true
    vault_gen_cert_fqdn: hostname.example.com
    #vault_gen_cert_ip_sans: 192.168.1.1 #Only set if access via the ip should be permitted or if there is an alternative
    vault_gen_cert_install: true # true for installing cert directly to the path 
    vault_gen_cert_install_pub_path: /tmp/public_key.pem
    vault_gen_cert_install_priv_path: /tmp/private_key.pem
    vault_gen_cert_install_ca_path: /tmp/ca_key.crt

  roles:
    - install-configure-vault
```

### Playbook: inventory.ini
```
[myserver]
example.com
```
</details>

<details><summary>Upload file from remote machine to vault (click here)</summary>

### Ansible command:
```
ansible-playbook -i inventory.ini playbook.yml
```

### Playbook: playbook.yml
```
---
- hosts: "all"
  gather_facts: true
  become: false
  vars:
    # default configuration
    vault_url: https://example.com:8200
    #vault_username: username
    #vault_password: password
    vault_token: <root_token> # or uncomment vault user+pw and use a admin user account

    vault_kv_write: true
    vault_kv_write_file_data:
      - secret_name: test
        secret_engine: labul
        path: /tmp/test.txt
        filename: test # The key on vault server, needed for extracting 

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
DATE         WHO            WHAT
20201013     Marcel Zapf    Init readme, role wip
20201014     Marcel Zapf    Implementet new Features
20201015     Marcel Zapf    Bug fixing
20201019     Marcel Zapf    Logic added that allows further vault tasks to be linked directly after installation
20201020     Marcel Zapf    Better logic vault creates his own cert for webinterface and api, api awx bugfix move execution host from localhost to vars
20201021     Marcel Zapf    Added support for additionally ip address with domain name (Vault CA)
20201022     Marcel Zapf    Move error handler to own file, fix json override bug, add ip_sans to ca installation
20201023     Marcel Zapf    Add missing task for installing issuing ca key
20201026     Marcel Zapf    Fixed ip_san error while running error handler
```

License
-------

BSD

Author Information
------------------

Marcel Zapf; 10/2020; SVA GmbH