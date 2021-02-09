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
- Add key value data
- Upload local files to vault secret store
- Generate .bashrc file for fully automated environment handling
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
  version: 1.4.1
- name: community.general
  version: 1.3.4
- name: community.crypto
  version: 1.3.0
- name: ansible.posix
  version: 1.1.1

EOF
ansible-galaxy install -r /tmp/requirements.yaml --force && ansible-galaxy collection install -r /tmp/requirements.yaml -f
```
</details>

For more information about stuttgart-things role installation visit: [Stuttgart-Things howto install role](https://codehub.sva.de/Lab/stuttgart-things/meta/documentation/doc-as-code/-/blob/master/howtos/howto-install-role.md)

## Howto install Vault Root CA in windows 10 OS Systems (BETA)

- Download the powershell script located in /meta folder
- Make sure your windows version have the version 2004 or greater
- Run on a powershell commandline with admin privileges "Set-ExecutionPolicy RemoteSigned" to make sure scripts are allowed on your system
- Run the downloaded script and follow the wizard

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

    # Output install config
    vault_install_save_conf_path: /tmp/vault_config.txt #optional comment out if not needed

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

<details><summary>Write key value secrets (kv)</summary>

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

    # Write data to KV database
    vault_kv_write: true
    vault_kv_write_data:
      - secret_name: awx_server
        secret_engine: labul
        kv:
          ip: 1.2.3.4
          username: user
          password: secret
      - secret_name: vcenter
        secret_engine: labda
        kv:
          ip: 1.2.3.4
          username: user
          password: secret

  roles:
    - install-configure-vault
```
</details>

<details><summary>Generate bashrc config add alias for inject vault secrets to environment vars</summary>

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

    # Generate bashrc
    vault_bashrc: true
    vault_bashrc_mod:
    labul_vault:              # <- alias command
      labul:                  # <- secret engine
        - awx                 # <- secret name
        - vcenter             # <- another secret name
      ocp4:                   # <- secret engine
        - pull_secret         # <- secret name
    labda_vault:              # <- alias command
      labda:                  # <- secret engine
        - awx                 # <- secret name
        - vcenter             # <- another secret name
      ocp4:                   # <- secret engine
        - pull_secret         # <- secret name

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
DATE            WHO            WHAT
2020-10-13      Marcel Zapf    Init readme, role wip
2020-10-14      Marcel Zapf    Implementet new Features
2020-10-15      Marcel Zapf    Bug fixing
2020-10-19      Marcel Zapf    Logic added that allows further vault tasks to be linked directly after installation
2020-10-20      Marcel Zapf    Better logic vault creates his own cert for webinterface and api, api awx bugfix move execution host from localhost to vars
2020-10-21      Marcel Zapf    Added support for additionally ip address with domain name (Vault CA)
2020-10-22      Marcel Zapf    Move error handler to own file, fix json override bug, add ip_sans to ca installation
2020-10-23      Marcel Zapf    Add missing task for installing issuing ca key
2020-10-26      Marcel Zapf    Fixed ip_san error while running error handler
2020-10-28      Marcel Zapf    Add bashrc generator add kv upload
2020-11-03      Marcel Zapf    Add feature for saving config after vault installation
2020-11-12      Marcel Zapf    Add windows root ca installing process to readme
2020-11-17      Marcel Zapf    Fix some known bugs and add aditional default vars for vault specific certificate
2021-01-13      Marcel Zapf    Readme update
2021-01-20      Marcel Zapf    Move container vars to defaults for better freze collections version
2021-01-27      Marcel Zapf    ID for the CA certificate added to support more Vault CAs
2021-02-05      Marcel Zapf    Added feature to delete a secret
```

License
-------

BSD

Author Information
------------------

Marcel Zapf; 10/2020; SVA GmbH
